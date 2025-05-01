function youtube
    if test (count $argv) -eq 0
        echo "Usage: youtube [search terms]"
        return 1
    end
    set search_query (string join '+' $argv)
    nohup xdg-open "https://www.youtube.com/results?search_query=$search_query" >/dev/null 2>&1 &
end
