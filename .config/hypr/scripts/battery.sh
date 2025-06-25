#!/usr/bin/env bash
# Battery monitor: continuously checks battery and adjusts Hyprland settings

# Wait for acpi and swaync to load
sleep 3

# Check if acpi is installed
if ! command -v acpi &>/dev/null; then
    notify-send -u critical -i dialog-error "Battery Notifier" "Error: 'acpi' is not installed!"
    exit 1
fi

# Main loop - run battery check every 60 seconds
echo "Starting battery monitor..."
while true; do
    ~/.config/hypr/scripts/checkbattery.sh
    sleep 60
done
