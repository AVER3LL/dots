#!/bin/bash

# Font name
FONT_NAME="M PLUS Rounded 1c"

# Check if the font is already installed
if fc-list | grep -q "$FONT_NAME"; then
    echo "Font '$FONT_NAME' is already installed."
    exit 0
fi

# Create a directory for fonts if it doesn't exist
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Download and unzip the font
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit

wget --user-agent="Mozilla/5.0" "https://fonts.google.com/download?family=M+PLUS+Rounded+1c" -O m-plus-rounded-1c.zip
unzip m-plus-rounded-1c.zip -d "$FONT_DIR"

# Clean up
cd -
rm -rf "$TMP_DIR"

# Update the font cache
fc-cache -f -v

echo "Font '$FONT_NAME' installed successfully."
