#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar/themes/main/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/themes/main/style.css"

killall waybar || waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &
