#!/bin/bash

killall waybar
pkill waybar
sleep 0.5

~/.config/waybar/launch.sh
