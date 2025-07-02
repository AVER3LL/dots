#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar/themes/full/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/themes/full/style.css"

killall waybar || waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" &
