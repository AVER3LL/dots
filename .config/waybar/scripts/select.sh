#!/bin/bash

# Configuration
readonly WAYBAR_DIR="$HOME/.config/waybar"
readonly LAUNCHER="$WAYBAR_DIR/toggle.sh"
readonly THEME_DIR="$WAYBAR_DIR/themes"

# Theme definitions with icons and descriptions
declare -A THEMES=(
    ["main"]="󰕰|Default horizontal bar layout"
    ["full"]="󰍹|Complete top bar with all modules"
    ["vertical"]="|Side-mounted vertical bar"
    ["windows"]="󰖟|Bottom bar Windows-style layout"
    ["zen"]="󱎴|Minimal clean interface"
    ["both"]="󰍺|Dual bar setup (top + bottom)"
    ["minimal"]="󰘴|Top bar with no gap"
    ["test"]="T|For testing purposes"
)

# Display menu of available themes
show_menu() {
    local menu_entries=()
    local current_theme
    current_theme=$(get_current_theme)

    for theme in "${!THEMES[@]}"; do
        IFS='|' read -r icon desc <<<"${THEMES[$theme]}"

        # If it's the current theme, append [selected]
        if [[ "$theme" == "$current_theme" ]]; then
            desc+=" <span foreground='gold'><b><i>[selected]</i></b></span>"
        fi

        menu_entries+=("$icon  $theme - $desc")
    done

    printf '%s\n' "${menu_entries[@]}"
}

# Get current active theme (optional - shows current selection)
get_current_theme() {
    if [[ -f "$LAUNCHER" ]]; then
        # Try to determine current theme by checking which theme's toggle.sh matches
        for theme in "${!THEMES[@]}"; do
            local theme_launcher="$THEME_DIR/${theme}/toggle.sh"
            if [[ -f "$theme_launcher" ]] && cmp -s "$LAUNCHER" "$theme_launcher"; then
                echo "$theme"
                return
            fi
        done
    fi
    echo "unknown"
}

# Reload waybar with selected theme
reload_waybar() {
    local theme_launcher="$1"
    local theme_name="$2"

    if [[ ! -f "$theme_launcher" ]]; then
        notify-send "Waybar Theme Error" "Theme launcher not found: $theme_name" -u critical
        echo "Error: Theme launcher not found: $theme_launcher" >&2
        return 1
    fi

    # Copy theme launcher to active config
    if ! cp "$theme_launcher" "$LAUNCHER"; then
        notify-send "Waybar Theme Error" "Failed to copy theme launcher" -u critical
        echo "Error: Failed to copy theme launcher" >&2
        return 1
    fi

    # Make launcher executable
    chmod +x "$LAUNCHER"

    # Restart waybar if running
    if pgrep -x waybar >/dev/null; then
        killall waybar
        sleep 0.5 # Give waybar time to fully close
        echo "Killed waybar"
    fi

    value_kitty=140
    ghostty_value=40
    if [ "$theme_name" = "test" ] || [ "$theme_name" = "vertical" ]; then
        value_kitty=145
        ghostty_value=45
    fi

    if [ "$theme_name" = "vertical" ]; then
        sed -i '/layerrule = animation slide/s/\btop\b/left/' "$HOME/.config/hypr/config/windowrules.conf"
    else
        sed -i '/layerrule = animation slide/s/\bleft\b/top/' "$HOME/.config/hypr/config/windowrules.conf"
    fi

    # Update kitty config
    sed -i "s/\(cell_height[[:space:]]*\)[0-9]\+%/\1${value_kitty}%/" "$HOME/.config/kitty/kitty.conf"

    if pgrep -x kitty >/dev/null; then
        # This does not work no matter how I try it
        kitty @ --to $KITTY_LISTEN_ON load-config kitty.conf
        echo "ran the command"
    fi

    sed -i \
        -e "s/^adjust-cell-height\s*=.*/adjust-cell-height = ${ghostty_value}%/" \
        "$HOME/.config/ghostty/config"

    # Start waybar with new theme
    if [[ -x "$LAUNCHER" ]]; then
        "$LAUNCHER" &
        notify-send "Waybar Theme" "Applied theme: $theme_name" -t 2000
        echo "Started waybar with theme: $theme_name"
    else
        notify-send "Waybar Theme Error" "Launcher is not executable" -u critical
        echo "Error: Launcher is not executable: $LAUNCHER" >&2
        return 1
    fi
}

# Validate theme directories
validate_themes() {
    local missing_themes=()

    for theme in "${!THEMES[@]}"; do
        local theme_dir="$THEME_DIR/${theme}"
        local theme_launcher="$theme_dir/toggle.sh"

        if [[ ! -d "$theme_dir" ]]; then
            missing_themes+=("$theme (directory missing)")
        elif [[ ! -f "$theme_launcher" ]]; then
            missing_themes+=("$theme (toggle.sh missing)")
        fi
    done

    if [[ ${#missing_themes[@]} -gt 0 ]]; then
        echo "Warning: Some themes are not properly configured:" >&2
        printf "  - %s\n" "${missing_themes[@]}" >&2
        return 1
    fi

    return 0
}

# Main function
main() {
    # Check if required directories exist
    for dir in "$WAYBAR_DIR" "$THEME_DIR"; do
        if [[ ! -d "$dir" ]]; then
            notify-send "Waybar Theme Error" "Directory not found: $dir" -u critical
            echo "Error: Directory not found: $dir" >&2
            exit 1
        fi
    done

    # Validate theme configurations
    validate_themes

    # Get current theme for highlighting (optional)
    local current_theme
    current_theme=$(get_current_theme)

    # Create rofi prompt with current theme info
    local prompt="Waybar Theme..."

    # Show menu and get user selection
    local choice
    choice=$(show_menu | rofi \
        -dmenu \
        -i \
        -p "$prompt" \
        -theme ~/.config/rofi/system.rasi \
        -no-show-icons \
        -markup-rows -format 's')

    # Exit if no selection made or ESC pressed
    if [[ -z "$choice" ]]; then
        echo "No theme selected"
        exit 1
    fi

    # Extract theme name from selection (get first word after icon)
    local selected_theme
    selected_theme=$(echo "$choice" | awk '{print $2}')

    echo "Selected theme: $selected_theme"

    # Find matching theme
    if [[ -n "${THEMES[$selected_theme]}" ]]; then
        local theme_dir="$selected_theme"
        local theme_launcher="$THEME_DIR/$theme_dir/toggle.sh"

        echo "Loading theme: $theme_dir"
        reload_waybar "$theme_launcher" "$selected_theme"
    else
        notify-send "Waybar Theme Error" "No theme mapping found for: $selected_theme" -u critical
        echo "Error: No theme mapping found for: $selected_theme" >&2
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
