#!/bin/bash

# Change to the fabric config directory
cd "$HOME/.config/fabric" || {
    echo "Error: Could not change to $HOME/.config/fabric"
    exit 1
}

# Source the virtual environment
source venv/bin/activate || {
    echo "Error: Could not activate virtual environment"
    exit 1
}

# Run the main module
python -m main "$@" &
