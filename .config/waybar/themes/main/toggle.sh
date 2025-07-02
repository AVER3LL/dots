#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar/themes/main/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/themes/main/style.css"

if pgrep -x waybar >/dev/null; then
    # Waybar is running, kill it
    killall waybar
else
    # Waybar is not running, start it
    waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &
fi
