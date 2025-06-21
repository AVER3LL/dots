#!/usr/bin/env bash
# Battery monitor: continuously checks battery and adjusts Hyprland settings

# Wait for acpi and swaync to load
sleep 3

# Check if acpi is installed
if ! command -v acpi &>/dev/null; then
    notify-send -u critical -i dialog-error "Battery Notifier" "Error: 'acpi' is not installed!"
    exit 1
fi

perform_battery_check() {
    # Get battery info
    local level=$(acpi | grep -oP '\d+%' | tr -d '%')
    local status=$(acpi | grep -oP 'Charging|Discharging')

    if [ -z "$level" ] || [ -z "$status" ]; then
        echo "Could not determine battery level or status."
        return
    fi

    local flag="/tmp/hypr_battery_low"
    local charge_flag="/tmp/hypr_battery_high"

    # Low battery condition (< 40% and discharging)
    if [ "$level" -lt 40 ] && [ "$status" = "Discharging" ]; then
        # Get current settings
        local blur=$(hyprctl -j getoption decoration:blur:enabled | jq -r '.int')
        local shadow=$(hyprctl -j getoption decoration:shadow:enabled | jq -r '.int')
        local animation=$(hyprctl -j getoption animations:enabled | jq -r '.int')

        # Build command to disable features
        local CMD=""
        [ "$blur" -eq 1 ] && CMD="${CMD}keyword decoration:blur:enabled 0;"
        [ "$shadow" -eq 1 ] && CMD="${CMD}keyword decoration:shadow:enabled 0;"
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
            # Re-enable features
            hyprctl reload

            # Determine appropriate message and icon
            if [ "$status" = "Charging" ]; then
                local icon="battery-full-charging-symbolic"
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
}

# Main loop - run battery check every 60 seconds
echo "Starting battery monitor..."
while true; do
    perform_battery_check
    sleep 60
done
