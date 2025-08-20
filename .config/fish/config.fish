if not status is-interactive
    return 0
end

fzf --fish | source
starship init fish | source
zoxide init fish | source

fish_config theme choose "Matugen"
