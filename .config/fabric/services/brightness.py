import os

from fabric.core.service import Property, Service, Signal
from fabric.utils import exec_shell_command_async, monitor_file
from gi.repository import GLib
from loguru import logger


def exec_brightnessctl_async(args: str):
    exec_shell_command_async(f"brightnessctl {args}", lambda _: None)


class BrightnessService(Service):
    """Service to manage screen brightness levels."""

    instance = None

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super().__new__(cls)
        return cls.instance

    @staticmethod
    def get_initial():
        if BrightnessService.instance is None:
            BrightnessService.instance = BrightnessService()

        return BrightnessService.instance

    @Signal
    def brightness_changed(self, value: int) -> None:
        """Signal emitted when screen brightness changes."""
        # Implement as needed for your application

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        # Discover screen backlight device
        try:
            self.screen_device = os.listdir("/sys/class/backlight")
            self.screen_device = self.screen_device[0] if self.screen_device else ""
        except FileNotFoundError:
            logger.error("No backlight devices found, brightness control disabled")
            self.screen_device = ""

        # Path for screen backlight control
        self.screen_backlight_path: str = f"/sys/class/backlight/{self.screen_device}"

        # Initialize maximum brightness level
        self.max_screen = self.do_read_max_brightness(self.screen_backlight_path)

        if self.screen_device == "":
            return

        # Monitor screen brightness file
        self.screen_monitor = monitor_file(f"{self.screen_backlight_path}/brightness")

        self.screen_monitor.connect(
            "changed",
            lambda _, file, *args: self.emit(
                "brightness_changed",
                round(int(file.load_bytes()[0].get_data())),
            ),
        )

        # Log the initialization of the service
        logger.info(f"Brightness service initialized for device: {self.screen_device}")

    def do_read_max_brightness(self, path: str) -> int:
        # Reads the maximum brightness value from the specified path.
        max_brightness_path = os.path.join(path, "max_brightness")
        if os.path.exists(max_brightness_path):
            with open(max_brightness_path) as f:
                return int(f.readline())
        return -1  # Return -1 if file doesn't exist, indicating an error.

    @Property(int, "read-write")
    def screen_brightness(self) -> int:
        if not self.screen_backlight_path:
            logger.warning("Cannot get brightness: no screen device.")
            return -1
        # Property to get or set the screen brightness.
        brightness_path = os.path.join(self.screen_backlight_path, "brightness")
        if os.path.exists(brightness_path):
            with open(brightness_path) as f:
                return int(f.readline())
        logger.warning(f"Brightness file does not exist: {brightness_path}")
        return -1  # Return -1 if file doesn't exist, indicating error.

    @screen_brightness.setter
    def screen_brightness(self, value: int):
        if not self.screen_backlight_path:
            logger.warning("Cannot set brightness: no screen device.")
            return
        # Setter for screen brightness property.
        if not (0 <= value <= self.max_screen):
            value = max(0, min(value, self.max_screen))

        try:
            exec_brightnessctl_async(f"--device '{self.screen_device}' set {value}")
            self.emit("brightness_changed", int((value / self.max_screen) * 100))
        except GLib.Error as e:
            logger.error(f"Error setting screen brightness: {e.message}")
        except Exception as e:
            logger.exception(f"Unexpected error setting screen brightness: {e}")

    @Property(int, "readable")
    def screen_brightness_percentage(self):
        if not self.screen_backlight_path or self.max_screen <= 0:
            return 0
        current_brightness = self.screen_brightness
        return int((current_brightness / self.max_screen) * 100)
