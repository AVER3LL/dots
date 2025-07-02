#!/bin/bash

# Configuration
readonly WAYBAR_DIR="$HOME/.config/waybar"
readonly LAUNCHER="$WAYBAR_DIR/toggle.sh"
readonly ASSETS="$WAYBAR_DIR/assets"
readonly THEMES="$WAYBAR_DIR/themes"

# Theme mappings: image_name -> theme_directory
declare -A THEME_MAP=(
    ["main.png"]="main"
    ["top.png"]="full"
    ["vertical.png"]="vertical"
    ["bottom.png"]="windows"
    ["zen.png"]="both"
)

# Display menu of available wallpaper images
show_menu() {
    find "$ASSETS" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) |
        awk '{print "img:"$0}' 2>/dev/null
}

# Reload waybar with selected theme
reload_waybar() {
    local theme_launcher="$1"

    if [[ ! -f "$theme_launcher" ]]; then
        echo "Error: Theme launcher not found: $theme_launcher" >&2
        return 1
    fi

    # Copy theme launcher to active config
    if ! cp "$theme_launcher" "$LAUNCHER"; then
        echo "Error: Failed to copy theme launcher" >&2
        return 1
    fi

    # Restart waybar if running
    if pgrep -x waybar >/dev/null; then
        pkill waybar
    fi

    # Start waybar with new theme
    if [[ -x "$LAUNCHER" ]]; then
        "$LAUNCHER"
    else
        echo "Error: Launcher is not executable: $LAUNCHER" >&2
        return 1
    fi
}

# Main function
main() {
    # Check if required directories exist
    for dir in "$WAYBAR_DIR" "$ASSETS" "$THEMES"; do
        if [[ ! -d "$dir" ]]; then
            echo "Error: Directory not found: $dir" >&2
            exit 1
        fi
    done

    # Show menu and get user selection
    local choice
    choice=$(show_menu | wofi \
        -c ~/.config/wofi/waybar \
        -s ~/.config/wofi/style-waybar.css \
        --show dmenu \
        --prompt "  Select Waybar Theme (Scroll with Arrows)" \
        -n)

    # Exit if no selection made
    if [[ -z "$choice" ]]; then
        echo "No theme selected"
        exit 0
    fi

    # Extract wallpaper path from selection
    local selected_wallpaper
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    # Get just the filename for lookup
    local image_name
    image_name=$(basename "$selected_wallpaper")

    echo "Selected: $selected_wallpaper"

    # Find matching theme
    if [[ -n "${THEME_MAP[$image_name]}" ]]; then
        local theme_dir="${THEME_MAP[$image_name]}"
        local theme_launcher="$THEMES/$theme_dir/toggle.sh"

        echo "Loading theme: $theme_dir"
        reload_waybar "$theme_launcher"
    else
        echo "Error: No theme mapping found for: $image_name" >&2
        exit 1
    fi
}

# Run main function
main "$@"
