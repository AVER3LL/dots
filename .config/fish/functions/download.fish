function download
    if not type -q yt-dlp
        echo "yt-dlp is not installed. Please install it first."
        echo "You can install it using: pip install yt-dlp"
        return 1
    end

    if test (count $argv) -lt 2
        echo "Usage: download [URL] [format]"
        echo "format: 'video' for video+audio, 'audio' for audio only"
        return 1
    end

    set url $argv[1]
    set format $argv[2]

    switch $format
        case "video"
            echo "Downloading video..."
            yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "%(title)s.%(ext)s" "$url"
        case "audio"
            echo "Downloading audio..."
            yt-dlp -f "ba" -x --audio-format mp3 -o "%(title)s.%(ext)s" "$url"
        case '*'
            echo "Invalid format. Use 'video' or 'audio'"
            return 1
    end
end
