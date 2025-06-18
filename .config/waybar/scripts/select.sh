#!/bin/bash
WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config.jsonc"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"

menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

reload_waybar() {
    local theme_style="$1"
    local theme_config="$2"

    # Copy theme files to active config
    cat "$theme_style" >"$STYLECSS"
    cat "$theme_config" >"$CONFIG"

    # Check if waybar is running and restart/start accordingly
    if pgrep -x waybar >/dev/null; then
        pkill waybar && waybar
    else
        waybar
    fi
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/waybar -s ~/.config/wofi/style-waybar.css --show dmenu --prompt "  Select Waybar (Scroll with Arrows)" -n)
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    echo $selected_wallpaper

    if [[ "$selected_wallpaper" == "$ASSETS/main.png" ]]; then
        reload_waybar "$THEMES/main/style.css" "$THEMES/main/config.jsonc"
    elif [[ "$selected_wallpaper" == "$ASSETS/top.png" ]]; then
        reload_waybar "$THEMES/full/style.css" "$THEMES/full/config.jsonc"
    elif [[ "$selected_wallpaper" == "$ASSETS/vertical.png" ]]; then
        reload_waybar "$THEMES/vertical/style.css" "$THEMES/vertical/config.jsonc"
    elif [[ "$selected_wallpaper" == "$ASSETS/bottom.png" ]]; then
        reload_waybar "$THEMES/windows/style.css" "$THEMES/windows/config.jsonc"
    fi
}

main
