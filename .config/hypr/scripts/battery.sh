#!/usr/bin/env bash

# Battery script: if battery < 40%, disable blur and animations

if ! command -v acpi &>/dev/null; then
    echo "acpi is not installed. Exiting."
    exit 1
fi

level=$(acpi | grep -oP '\d+%' | tr -d '%')
status=$(acpi | grep -oP 'Charging|Discharging')

if [ -z "$level" ] || [ -z "$status" ]; then
    echo "Could not determine battery level or status."
    exit 1
fi

flag="/tmp/hypr_battery_low"

if [ "$level" -lt 40 ] && [ "$status" = "Discharging" ]; then
    CMD=""
    blur=$(hyprctl -j getoption decoration:blur:enabled | jq -r '.int')
    animation=$(hyprctl -j getoption animations:enabled | jq -r '.int')

    # [ "$blur" -eq 1 ] && hyprctl keyword decoration:blur:enabled 0
    # [ "$animation" -eq 1 ] && hyprctl keyword animations:enabled 0

    [ "$blur" -eq 1 ] && CMD="${CMD}keyword decoration:blur:enabled 0;"
    [ "$animation" -eq 1 ] && CMD="${CMD}keyword animations:enabled 0;"

    if [ -n "$CMD" ]; then
        hyprctl --batch "$CMD"
    fi

    if [ ! -f "$flag" ]; then
        notify-send -t 5000 "Battery Low" "Battery level is ${level}%. Blur and animations disabled."
        touch "$flag"
    fi
else
    if [ -f "$flag" ]; then
        hyprctl reload
        notify-send -t 5000 "Battery Normal" "Battery at ${level}% or charging. Settings restored."
        rm "$flag"
    fi
fi
