#!/bin/bash

if ! pgrep -x swaync >/dev/null; then
    killall -9 mako
    swaync >/dev/null 2>&1 &
    wait
    notify-send "Launched swaync"
fi

swaync-client -t
