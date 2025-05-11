#!/bin/bash

# If run with --click argument, stop wf-recorder
if [[ "$1" == "--click" ]]; then
    pkill -INT -x wf-recorder && notify-send -h string:wf-recorder:record -t 1000 "Recording Stopped"
    exit 0
fi

# If not recording, exit silently (Waybar hides the module)
if ! pgrep -x "wf-recorder" >/dev/null; then
    exit 1
fi

# If recording, display red dot
echo '{"text":"🔴", "tooltip": "Click to stop recording", "class": "recording"}'
