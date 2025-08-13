from time import sleep
from typing import Literal

import gi
import psutil
from fabric import Fabricator
from fabric.utils import bulk_connect
from fabric.widgets.label import Label
from gi.repository import Gdk

from .icons import symbolic_icons, text_icons

gi.require_versions({"Gtk": "3.0", "Gdk": "3.0", "GdkPixbuf": "2.0"})


def stats_poll(fabricator):
    while True:
        yield {
            "cpu_usage": round(psutil.cpu_percent(), 1),
            "cpu_freq": psutil.cpu_freq(),
            "temperature": psutil.sensors_temperatures(),
            "ram_usage": round(psutil.virtual_memory().percent, 1),
            "memory": psutil.virtual_memory(),
            "disk": psutil.disk_usage("/"),
        }
        sleep(1)


# Function to setup cursor hover
def setup_cursor_hover(
    widget, cursor_name: Literal["pointer", "crosshair", "grab"] = "pointer"
):
    display = Gdk.Display.get_default()
    cursor = Gdk.Cursor.new_from_name(display, cursor_name)

    def on_enter_notify_event(widget, _):
        widget.get_window().set_cursor(cursor)

    def on_leave_notify_event(widget, _):
        widget.get_window().set_cursor(cursor)

    bulk_connect(
        widget,
        {
            "enter-notify-event": on_enter_notify_event,
            "leave-notify-event": on_leave_notify_event,
        },
    )


def nerd_font_icon(icon: str, props=None, name="nerd-icon") -> Label:
    label_props = {
        "label": str(icon),  # Directly use the provided icon name
        "name": name,
        "h_align": "center",  # Align horizontally
        "v_align": "center",  # Align vertically
    }

    if props:
        label_props.update(props)

    return Label(**label_props)


# Function to get the volume icons
def get_audio_icon_name(volume: int, is_muted: bool):
    if volume <= 0 or is_muted:
        return {
            "text_icon": text_icons["volume"]["muted"],
            "icon": symbolic_icons["audio"]["volume"]["muted"],
        }
    if volume > 0 and volume <= 32:
        return {
            "text_icon": text_icons["volume"]["low"],
            "icon": symbolic_icons["audio"]["volume"]["low"],
        }
    if volume > 32 and volume <= 66:
        return {
            "text_icon": text_icons["volume"]["medium"],
            "icon": symbolic_icons["audio"]["volume"]["medium"],
        }
    if volume > 66 and volume <= 100:
        return {
            "text_icon": text_icons["volume"]["high"],
            "icon": symbolic_icons["audio"]["volume"]["high"],
        }
    else:
        return {
            "text_icon": text_icons["volume"]["overamplified"],
            "icon": symbolic_icons["audio"]["volume"]["overamplified"],
        }


# Function to get the brightness icons
def get_brightness_icon_name(level: int) -> dict[Literal["icon_text", "icon"], str]:
    if level <= 0:
        return {
            "icon_text": text_icons["brightness"]["off"],
            "icon": symbolic_icons["brightness"]["off"],
        }

    if level <= 32:
        return {
            "icon_text": text_icons["brightness"]["low"],
            "icon": symbolic_icons["brightness"]["low"],
        }
    if level <= 66:
        return {
            "icon_text": text_icons["brightness"]["medium"],
            "icon": symbolic_icons["brightness"]["medium"],
        }
    return {
        "icon_text": text_icons["brightness"]["high"],
        "icon": symbolic_icons["brightness"]["high"],
    }


reusable_fabricator = Fabricator(
    interval=1000,  # ms
    poll_from=lambda *_: "echo",  # Dummy function to keep it alive
)
