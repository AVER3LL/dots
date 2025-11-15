#!/bin/bash

# Script to apply a theme
# Usage: ./apply_theme.sh <theme_name>
# Copies the theme files to their respective locations and runs post-hooks

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <theme_name>"
    exit 1
fi

THEME_NAME="$1"
THEME_DIR="$HOME/.config/matugen/themes/$THEME_NAME"

if [ ! -d "$THEME_DIR" ]; then
    echo "Theme '$THEME_NAME' not found in $HOME/.config/matugen/themes/"
    exit 1
fi

killall -9 waybar || true

# Copy files
cp "$THEME_DIR/colors.css" "$HOME/.config/waybar/colors.css"
cp "$THEME_DIR/hyprland-colors.conf" "$HOME/.config/hypr/colors.conf"
cp "$THEME_DIR/kitty-colors.conf" "$HOME/.config/kitty/theme/colors-matugen.conf"
cp "$THEME_DIR/ghostty-colors" "$HOME/.config/ghostty/themes/matugen"
cp "$THEME_DIR/gtk.css" "$HOME/.config/gtk-3.0/colors.css"
cp "$THEME_DIR/gtk.css" "$HOME/.config/gtk-4.0/colors.css"
cp "$THEME_DIR/Matugen.colors" "$HOME/.local/share/color-schemes/Matugen.colors"
cp "$THEME_DIR/colors.css" "$HOME/.config/wlogout/colors.css"
cp "$THEME_DIR/colors.css" "$HOME/.config/swaync/colors.css"
cp "$THEME_DIR/colors.css" "$HOME/.config/swayosd/colors.css"
cp "$THEME_DIR/vicinae.toml" "$HOME/.local/share/vicinae/themes/matugen.toml"
cp "$THEME_DIR/quickshell-colors.qml" "$HOME/.config/quickshell/shared/Colors.qml"
cp "$THEME_DIR/rofi-colors.rasi" "$HOME/.config/rofi/material-colors.rasi"
cp "$THEME_DIR/qtct-colors.conf" "$HOME/.config/qt6ct/colors/matugen.conf"
cp "$THEME_DIR/folder-color.txt" "$HOME/.cache/averell/papirus-folder.txt"
cp "$THEME_DIR/zathura-colors" "$HOME/.config/zathura/zathurarc"
cp "$THEME_DIR/alacritty.toml" "$HOME/.config/alacritty/colors.toml"
cp "$THEME_DIR/starship.toml" "$HOME/.config/starship.toml"
cp "$THEME_DIR/pywalfox-colors.json" "$HOME/.cache/wal/colors.json"
cp "$THEME_DIR/colors.fish" "$HOME/.config/fish/themes/Matugen.theme"
cp "$THEME_DIR/nvim.lua" "$HOME/.config/nvim/lua/config/generated.lua"

# Run post-hooks
# TODO: Delete those once we harmonize it with ~/.local/bin/walset-backend

~/.config/waybar/toggle.sh

hyprctl reload

~/.config/hypr/scripts/checkbattery.sh >/dev/null 2>&1 &

killall -SIGUSR1 kitty >/dev/null 2>&1 &

systemctl reload --user app-com.mitchellh.ghostty.service >/dev/null 2>&1 &

swaync-client -rs >/dev/null 2>&1 &

pywalfox update

vicinae vicinae://theme/set/matugen

fish -c "yes | fish_config theme save Matugen" 2>/dev/null &

notify-send "Theme '$THEME_NAME' applied successfully."
