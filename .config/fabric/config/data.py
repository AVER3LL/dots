import os

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gdk, GLib

APP_NAME = "averell-shell"
APP_NAME_CAP = "Averell-Shell"

USERNAME = os.getlogin()
HOSTNAME = os.uname().nodename
HOME_DIR = os.path.expanduser("~")

SHOW_CORNERS = False

WALLPAPER_DIR = os.path.expanduser("~/wallpaper/")

screen = Gdk.Screen.get_default()
CURRENT_WIDTH = screen.get_width()
CURRENT_HEIGHT = screen.get_height()
