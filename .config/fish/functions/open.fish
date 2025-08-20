
function open
    command nohup xdg-open $argv >/dev/null 2>&1 & disown
end
