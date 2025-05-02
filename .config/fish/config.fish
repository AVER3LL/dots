# Format man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

set fish_cursor_default block
set fish_cursor_insert block
fish_vi_key_bindings

# Set default editor
set -x VISUAL nvim
set -x EDITOR $VISUAL

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
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

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

function fish_greeting
    # fastfetch
    # echo "hello there"
end

function add_to_path_if_needed --argument path
    if test -d $path
        if not contains -- $path $PATH
            set -p PATH $path
        end
    end
end

function fish_user_key_bindings
    bind \e\[3~ delete-char
    bind \e\[3\;5~ kill-word
    bind \b backward-kill-word
    bind \e\[1\;5C forward-word
    bind \e\[1\;5D backward-word

    bind \cf zi
end

source ~/.config/fish/aliases.fish

starship init fish | source
zoxide init fish | source

# SDKMAN setup
set -x SDKMAN_DIR "$HOME/.sdkman"
if test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    bass source "$SDKMAN_DIR/bin/sdkman-init.sh"
end

# PATH additions (prepend in order)
add_to_path_if_needed $HOME/.config/herd-lite/bin
add_to_path_if_needed $HOME/development/flutter/bin
add_to_path_if_needed $HOME/.local/bin

# PHP INI scan path
set -x PHP_INI_SCAN_DIR "$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Add JAVA_HOME/bin to PATH if JAVA_HOME is set
if set -q JAVA_HOME
    # set -x PATH $JAVA_HOME/bin $PATH
    add_to_path_if_needed $JAVA_HOME/bin
end
