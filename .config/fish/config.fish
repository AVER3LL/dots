if not status is-interactive
    return 0
end

fzf --fish | source
starship init fish | source
zoxide init fish | source

fish_config theme choose "Matugen"
# set -g fish_cursor_default block blinkon0

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/averell/.ghcup/bin $PATH # ghcup-env