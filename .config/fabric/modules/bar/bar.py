from fabric.system_tray.widgets import SystemTray
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.wayland import WaylandWindow as Window

from .battery import BatteryWidget
from .brightness import BrightnessWidget
from .enhanced_system_tray import apply_enhanced_system_tray
from .hypridle import HyprIdleWidget
from .icon import Icon
from .volume import VolumeWidget
from .workspaces import MyWorkspaces

apply_enhanced_system_tray()


class StatusBar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            layer="top",
            name="status-bar",
            anchor="left top right",
            exclusivity="auto",
            **kwargs,
        )

        # top right bottom left
        # self.set_margin("9px 14px 0px 14px")

        self.date_time = DateTime(
            name="time",
            formatters=(
                "%H:%M",
                "%B %d  %R",
                "%a %d %b",
            ),
        )
        self.children = [
            CenterBox(
                start_children=[
                    # Icon(),
                    MyWorkspaces()
                ],
                end_children=[
                    SystemTray(name="systray", spacing=10, icon_size=20),
                    BrightnessWidget(),
                    VolumeWidget(),
                    HyprIdleWidget(),
                    BatteryWidget(),
                ],
                center_children=[self.date_time],
                spacing=5,
                v_align="center",
                size=40,
            )
        ]

    def toggle(self):
        """Toggle the visibility of the bar."""
        if self.is_visible():
            self.hide()
        else:
            self.show()
