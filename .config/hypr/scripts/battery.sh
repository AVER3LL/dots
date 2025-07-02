#!/usr/bin/env bash
# Battery monitor: continuously checks battery and adjusts Hyprland settings

# Use flock to prevent multiple instances
LOCK_FILE="/tmp/battery_monitor.lock"

# Try to acquire exclusive lock
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    echo "Battery monitor is already running"
    exit 1
fi

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

# Lock is automatically released when script exits
