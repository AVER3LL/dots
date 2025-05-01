function extract
    if test (count $argv) -eq 0
        echo "Usage: extract [file to extract]"
        return 1
    end

    set file $argv[1]
    if not test -f $file
        echo "'$file' is not a valid file"
        return 1
    end

    set filename (basename $file)
    set dirname (string replace -r '\.(tar\.(gz|bz2|xz|zst)|gz|bz2|zip|rar|7z|deb|Z)$' '' $filename)

    mkdir -p $dirname
    cd $dirname

    switch $file
        case '*.tar.bz2'
            tar xjf ../$file
        case '*.tar.gz'
            tar xzf ../$file
        case '*.bz2'
            bunzip2 ../$file
        case '*.rar'
            unrar x ../$file
        case '*.gz'
            gunzip ../$file
        case '*.tar'
            tar xf ../$file
        case '*.tbz2'
            tar xjf ../$file
        case '*.tgz'
            tar xzf ../$file
        case '*.zip'
            unzip ../$file
        case '*.Z'
            uncompress ../$file
        case '*.7z'
            7z x ../$file
        case '*.deb'
            ar x ../$file
        case '*.tar.xz'
            tar xf ../$file
        case '*.tar.zst'
            tar xf ../$file
        case '*'
            cd ..
            echo "'$file' cannot be extracted via extract()"
            return 1
    end

    cd ..
    echo "Extracted to directory: $dirname"
end
