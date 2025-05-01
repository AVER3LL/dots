function zi
    set result (zoxide query -i)
    if test -n "$result"
        cd "$result"
    end
end
