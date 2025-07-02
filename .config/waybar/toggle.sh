#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar/themes/both/config.jsonc"
WAYBAR_BOTTOM_CONFIG="$HOME/.config/waybar/themes/both/config-bottom.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/themes/both/style.css"
WAYBAR_BOTTOM_STYLE="$HOME/.config/waybar/themes/both/style-bottom.css"

# Function to check if waybar is running
is_waybar_running() {
    pgrep -x waybar >/dev/null
}

stop_waybar() {
    echo "Stopping waybar instances..."

    # Kill all waybar processes
    killall waybar 2>/dev/null

    echo "Waybar stopped"
}

start_waybar() {
    echo "Starting dual waybar setup..."

    # Start top waybar in background
    waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &

    # Start bottom waybar in background
    waybar -c "$WAYBAR_BOTTOM_CONFIG" -s "$WAYBAR_BOTTOM_STYLE" &
}

if is_waybar_running; then
    stop_waybar
else
    start_waybar
fi
