#!/bin/bash

# Configuration
readonly CACHE_DIR="$HOME/.cache/averell"
readonly LOCK_FILE="$CACHE_DIR/matugen.lock"
readonly THEMES_DIR="$HOME/.config/matugen/themes"
readonly SCRIPTS_DIR="$HOME/.config/matugen/scripts/"
readonly WALLPAPER_CHOOSER="$HOME/.local/bin/"

# Theme definitions
declare -a THEMES=("everforest" "noir" "Material you")

# Get current active theme
get_current_theme() {
    if [[ -f "$LOCK_FILE" ]]; then
        cat "$LOCK_FILE"
    else
        echo "Material you"
    fi
}

# Display menu of available themes
show_menu() {
    local menu_items=""
    local last_index=$((${#THEMES[@]} - 1))
    local current_theme
    current_theme=$(get_current_theme)

    for i in "${!THEMES[@]}"; do
        local theme="${THEMES[$i]}"
        if [[ "$theme" == "$current_theme" ]]; then
            menu_items+="$theme   <span foreground='gold'><b><i>[selected]</i></b></span>"
            # menu_items+="$theme  <span foreground='green'>✔</span>"
        else
            menu_items+="$theme"
        fi
        [[ $i -ne $last_index ]] && menu_items+="\n"
    done

    echo -e "$menu_items"
}

# Handle theme selection
apply_theme() {
    local selected_theme="$1"

    if [[ "$selected_theme" == "Material you" ]]; then
        # Delete lock file for Material you
        if [[ -f "$LOCK_FILE" ]]; then
            rm "$LOCK_FILE"
            $WALLPAPER_CHOOSER/walset
            echo "Switched to Material you theme"
        fi
    else
        # Create lock file for static themes
        mkdir -p "$CACHE_DIR"
        echo "$selected_theme" > "$LOCK_FILE"
        $SCRIPTS_DIR/apply_theme.sh "$selected_theme"
        echo "Switched to $selected_theme theme"
    fi
}

# Main function
main() {
    # Check if themes directory exists
    if [[ ! -d "$THEMES_DIR" ]]; then
        echo "Error: Themes directory not found: $THEMES_DIR" >&2
        exit 1
    fi

    # Show menu and get user selection
    local choice
    choice=$(show_menu | rofi \
        -dmenu \
        -i \
        -p "Choose Theme" \
        -theme ~/.config/rofi/system.rasi \
        -no-show-icons \
        -markup-rows \
        -format 's')

    # Exit if no selection made or ESC pressed
    if [[ -z "$choice" ]]; then
        echo "No theme selected"
        exit 1
    fi

    # Extract theme name (remove markup)
    local selected_theme
    selected_theme=$(echo "$choice" | sed 's/ <span.*//')

    echo "Selected theme: $selected_theme"

    # Apply the selected theme
    apply_theme "$selected_theme"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
