#!/bin/bash

# Define the unique configuration and style files for the secondary Waybar instance
WAYBAR_CONFIG="$HOME/.config/waybar/themes/taskbar/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/themes/taskbar/style.css"

# Check if a Waybar instance with this specific configuration is running
if pgrep -af "waybar.*$WAYBAR_CONFIG" >/dev/null; then
    # If running, kill the instance
    pkill -f "$WAYBAR_CONFIG"
else
    # If not running, start the Waybar instance with the specific configuration
    waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &
fi
