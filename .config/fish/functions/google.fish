function google
    if test (count $argv) -eq 0
        echo "Usage: google [search terms]"
        return 1
    end
    set search_query (string join '+' $argv)
    nohup xdg-open "https://www.google.com/search?q=$search_query" >/dev/null 2>&1 &
end
