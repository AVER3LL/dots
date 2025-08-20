set -x PHP_INI_SCAN_DIR "$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

set -x VISUAL nvim
set -x EDITOR $VISUAL
set -x BROWSER firefox

# Disable fish greeting
set -U fish_greeting

# Man page formatting
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
