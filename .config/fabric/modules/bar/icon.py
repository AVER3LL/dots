import os

from fabric.utils import exec_shell_command_async
from fabric.widgets.button import Button


class Icon(Button):
    ICONS: list[str] = ["", "🐧"]
    CURRENT: int = 0

    @staticmethod
    def run_rofi(button, *_):
        rofi_path = os.path.expanduser("~/.config/rofi/launcher-vert.sh")
        exec_shell_command_async(rofi_path)

    @staticmethod
    def change_icon(button, *_):
        Icon.CURRENT = (Icon.CURRENT + 1) % len(Icon.ICONS)
        button.set_label(Icon.ICONS[Icon.CURRENT])

    def __init__(self, **kwargs):
        super().__init__(
            name="bar-icon",
            label=Icon.ICONS[Icon.CURRENT],
            on_clicked=Icon.run_rofi,
            **kwargs,
        )
