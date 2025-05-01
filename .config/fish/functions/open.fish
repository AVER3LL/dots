function open
    if test (count $argv) -eq 0
        echo "Usage: open [filename/directory]"
        return 1
    end

    for file in $argv
        if not test -e $file
            echo "Error: '$file' does not exist"
            continue
        end
        nohup xdg-open "$file" >/dev/null 2>&1 &
    end
end
