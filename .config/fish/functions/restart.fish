function restart
    set process $argv[1]
    if pgrep -x $process >/dev/null
        pkill -x $process
    end
    $process &
end