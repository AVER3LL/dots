#!/usr/bin/env bash
# Battery check script with lock protection

# Lock file to prevent multiple instances
LOCK_FILE="/tmp/checkbattery.lock"

# Use flock to prevent multiple instances running simultaneously
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    # Another instance is running, exit silently
    exit 0
fi

# Get battery info
level=$(acpi | grep -oP '\d+%' | tr -d '%')
status=$(acpi | grep -oP 'Charging|Discharging')

if [ -z "$level" ] || [ -z "$status" ]; then
    echo "Could not determine battery level or status."
    exit 1
fi

flag="/tmp/hypr_battery_low"
charge_flag="/tmp/hypr_battery_high"

# Low battery condition (< 40% and discharging)
if [ "$level" -lt 40 ] && [ "$status" = "Discharging" ]; then
    # Get current settings
    blur=$(hyprctl -j getoption decoration:blur:enabled | jq -r '.int')
    # shadow=$(hyprctl -j getoption decoration:shadow:enabled | jq -r '.int')
    animation=$(hyprctl -j getoption animations:enabled | jq -r '.int')

    # Build command to disable features
    CMD=""
    [ "$blur" -eq 1 ] && CMD="${CMD}keyword decoration:blur:enabled 0;"
    # [ "$shadow" -eq 1 ] && CMD="${CMD}keyword decoration:shadow:enabled 0;"
    [ "$animation" -eq 1 ] && CMD="${CMD}keyword animations:enabled 0;"

    # Apply changes if any
    if [ -n "$CMD" ]; then
        hyprctl --batch "$CMD"
    fi

    # Notify only once
    if [ ! -f "$flag" ]; then
        notify-send -t 5000 -i battery-caution-symbolic "Battery Low" \
            "Battery level is ${level}%. Blur and animations disabled to save power."
        touch "$flag"
    fi

    # Remove high battery flag if it exists
    [ -f "$charge_flag" ] && rm "$charge_flag"

# Battery is okay (>= 40% or charging)
else
    # If we were in low battery mode, restore settings
    if [ -f "$flag" ]; then
        # Re-enable features (consider storing original settings instead of reload)
        hyprctl reload

        # Determine appropriate message and icon
        if [ "$status" = "Charging" ]; then
            icon="battery-full-charging-symbolic"
            if [ "$level" -ge 80 ]; then
                notify-send -t 5000 -i "$icon" "Battery High" \
                    "Battery at ${level}%. Consider unplugging to preserve battery health. Settings restored."
            else
                notify-send -t 5000 -i "$icon" "Battery Charging" \
                    "Battery at ${level}% and charging. Settings restored."
            fi
        else
            notify-send -t 5000 -i battery-good-symbolic "Battery Normal" \
                "Battery at ${level}%. Settings restored."
        fi
        rm "$flag"
    fi

    # Additional notification for high battery while charging
    if [ "$status" = "Charging" ] && [ "$level" -ge 80 ]; then
        # Only notify once about overcharging
        if [ ! -f "$charge_flag" ]; then
            notify-send -t 5000 -i battery-full-charging-symbolic "Battery High" \
                "Battery at ${level}%. Consider unplugging to preserve battery health."
            touch "$charge_flag"
        fi
    else
        # Remove high battery flag when not charging or below 80%
        [ -f "$charge_flag" ] && rm "$charge_flag"
    fi
fi

# Lock is automatically released when script exits
