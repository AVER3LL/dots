# config.fish - Minimal, organized configuration

# Skip if not in interactive shell
if not status is-interactive
    return 0
end

### ENVIRONMENT VARIABLES ###
# Editor
set -x VISUAL nvim
set -x EDITOR $VISUAL

# Man page formatting
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# PHP configuration
set -x PHP_INI_SCAN_DIR "$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

### PATH MANAGEMENT ###
# Helper function to add directories to PATH if they exist and aren't already included
function add_to_path_if_needed --argument path
    if test -d $path; and not contains -- $path $PATH
        set -p PATH $path
    end
end

# PATH additions (prepend in order)
add_to_path_if_needed $HOME/.config/herd-lite/bin
add_to_path_if_needed $HOME/development/flutter/bin
add_to_path_if_needed $HOME/.local/bin
add_to_path_if_needed $HOME/Applications/depot_tools
add_to_path_if_needed $JAVA_HOME/bin

### KEY BINDINGS ###
# Set vi key bindings
set -g fish_key_bindings fish_vi_key_bindings
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one underscore

function fish_user_key_bindings
    bind \e\[3~ delete-char
    bind \e\[3\;5~ kill-word
    bind \b backward-kill-word
    bind \e\[1\;5C forward-word
    bind \e\[1\;5D backward-word
    bind \cf zi
end

# Functions for !! and !$ history substitution
function __history_previous_command
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint
    case "*"
        commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward
    case "*"
        commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

### UTILITIES ###
# Enhanced history command
function history
    builtin history --show-time='%F %T '
end

# File backup function
function backup --argument filename
    cp $filename $filename.bak
end

# Empty greeting (comment out if you want no greeting)
function fish_greeting
    # Uncomment one of these if you want a greeting
    # fastfetch
    # echo "hello there"
end

### EXTERNAL TOOLS ###
# Load aliases from separate file
source ~/.config/fish/aliases.fish

# Initialize tools
# function starship_transient_prompt_func
#   starship module character
# end
starship init fish | source
# enable_transience
zoxide init fish | source
fzf --fish | source

# SDKMAN setup
set -x SDKMAN_DIR "$HOME/.sdkman"
if test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    bass source "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# Load custom profile if it exists
if test -f ~/.fish_profile
    source ~/.fish_profile
end
