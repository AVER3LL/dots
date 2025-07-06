#!/bin/bash

# Reload waybar only if it is running
if pgrep -x waybar >/dev/null; then
    killall waybar
    pkill waybar

    ~/.config/waybar/toggle.sh
fi
