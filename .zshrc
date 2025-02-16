# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# bindkey -v
#
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-.]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=5
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/averell/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "^[[3~" delete-char # DEL
bindkey "^[[3;5~" delete-word # CTRL+DEL - delete a whole word after cursor
bindkey "^H" backward-delete-word # CTRL+BACKSPACE - delete a whole word before cursor
bindkey "^[[1;5C" forward-word # CTRL+ARROW_RIGHT - move cursor forward one word
bindkey "^[[1;5D" backward-word # CTRL+ARROW_LEFT - move cursor backward one word

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # ARROW_UP
bindkey "^[[B" down-line-or-beginning-search # ARROW_DOWN

export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
# Set the default editor for sudoedit or sudo -e
export VISUAL=nvim
export EDITOR="$VISUAL"

alias ls='lsd'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias cls='clear'
alias l='ls'
alias la='ls -a'
alias ll='ls -alFh'
alias v='nvim'
alias nv='neovide'
alias vim='nvim'
# alias cat='bat'
alias nf='neofetch'
alias ff='fastfetch'
alias cd='z'
alias lazy='NVIM_APPNAME=LazyVim nvim'
alias kvim='NVIM_APPNAME=Kickstart nvim'
alias nvtest='NVIM_APPNAME=NvTest nvim'
alias clera='clear'
alias lear='clear'
alias lera='clear'
alias lare='clear'
alias cleare='clear'
alias cler='clear'
alias clar='clear'
alias sl='ls'
alias gs='git status'

google() {
    if [ $# -eq 0 ]; then
        echo "Usage: google [search terms]"
        return 1
    fi
    search_query=$(echo "$*" | sed 's/ /+/g')
    (nohup xdg-open "https://www.google.com/search?q=$search_query" >/dev/null 2>&1 &)
}

youtube() {
    if [ $# -eq 0 ]; then
        echo "Usage: youtube [search terms]"
        return 1
    fi
    search_query=$(echo "$*" | sed 's/ /+/g')
    (nohup xdg-open "https://www.youtube.com/results?search_query=$search_query" >/dev/null 2>&1 &)
}

# YouTube downloader function
download() {
    if ! command -v yt-dlp &> /dev/null; then
        echo "yt-dlp is not installed. Please install it first."
        echo "You can install it using: pip install yt-dlp"
        return 1
    fi

    if [ $# -lt 2 ]; then
        echo "Usage: download [URL] [format]"
        echo "format: 'video' for video+audio, 'audio' for audio only"
        return 1
    fi

    URL=$1
    FORMAT=$2

    case $FORMAT in
        "video")
            echo "Downloading video..."
            yt-dlp -f "bv*+ba/b" \
                --merge-output-format mp4 \
                -o "%(title)s.%(ext)s" \
                "$URL"
            ;;
        "audio")
            echo "Downloading audio..."
            yt-dlp -f "ba" \
                -x --audio-format mp3 \
                -o "%(title)s.%(ext)s" \
                "$URL"
            ;;
        *)
            echo "Invalid format. Use 'video' or 'audio'"
            return 1
            ;;
    esac
}

open() {
    if [ $# -eq 0 ]; then
        echo "Usage: open [filename/directory]"
        return 1
    fi

    for file in "$@"; do
        if [ ! -e "$file" ]; then
            echo "Error: '$file' does not exist"
            continue
        fi
        (nohup xdg-open "$file" >/dev/null 2>&1 &)
    done
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
extract ()
{
    if [ $# -eq 0 ]; then
        echo "Usage: extract [file to extract]"
        return 1
    fi

    if [ ! -f "$1" ] ; then
        echo "'$1' is not a valid file"
        return 1
    fi

    # Get the filename without path
    filename=$(basename "$1")

    # Create directory name by removing the extension(s)
    dirname="${filename%.*}"
    # Handle double extensions like .tar.gz
    dirname="${dirname%.*}"

    # Create and enter the directory
    mkdir -p "$dirname"
    cd "$dirname" || return 1

    case "$1" in
        *.tar.bz2)   tar xjf "../$1"   ;;
        *.tar.gz)    tar xzf "../$1"   ;;
        *.bz2)       bunzip2 "../$1"   ;;
        *.rar)       unrar x "../$1"   ;;
        *.gz)        gunzip "../$1"    ;;
        *.tar)       tar xf "../$1"    ;;
        *.tbz2)      tar xjf "../$1"   ;;
        *.tgz)       tar xzf "../$1"   ;;
        *.zip)       unzip "../$1"     ;;
        *.Z)         uncompress "../$1" ;;
        *.7z)        7z x "../$1"      ;;
        *.deb)       ar x "../$1"      ;;
        *.tar.xz)    tar xf "../$1"    ;;
        *.tar.zst)   tar xf "../$1"    ;;
        *)
            cd ..
            echo "'$1' cannot be extracted via extract()"
            return 1
            ;;
    esac

    # Return to original directory
    cd ..
    echo "Extracted to directory: $dirname"
}

# continue download
alias wget="wget -c"
#userlist
alias userlist="cut -d: -f1 /etc/passwd | sort"
#update
alias update="sudo pacman -Syyu"
#hardware info --short
alias hw="hwinfo --short"
#audio check pulseaudio or pipewire
alias audio="pactl info | grep 'Server Name'"
# This will generate a list of explicitly installed packages
alias list="sudo pacman -Qqe"
#This will generate a list of explicitly installed packages without dependencies
alias listt="sudo pacman -Qqet"
# list of AUR packages
alias listaur="sudo pacman -Qqem"
#Switch to gdm
alias togdm="sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo 'Gdm is active - reboot now'"

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# if [[ -z "$TMUX" ]]; then
#   tmux attach-session -t default || tmux new-session -s default
# fi


# Evals
eval "$(zoxide init zsh)"
zi() {
    local result
    result=$(zoxide query -i)
    if [ -n "$result" ]; then
        cd "$result"
        zle reset-prompt
    fi
}

zle -N zi
bindkey "^f" zi
eval "$(starship init zsh)"
eval "$(batman --export-env)"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

[[ -f /home/averell/.dart-cli-completion/zsh-config.zsh ]] && . /home/averell/.dart-cli-completion/zsh-config.zsh || true

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/home/averell/.config/herd-lite/bin:$PATH"
export PATH="/home/averell/development/flutter/bin:$PATH"
export PATH="/home/averell/.local/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/averell/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export JAVA_HOME="/home/averell/.sdkman/candidates/java/17.0.0-tem/bin/java"
export PATH=$JAVA_HOME/bin:$PATH

alias rel="xrdb merge ~/.Xresources && kill -USR1 $(pidof st)"
