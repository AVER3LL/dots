# Replace ls with eza
# alias ls='lsd' # preferred listing
# alias la='ls -a'  # all files and dirs
# alias ll='ls -alFh'  # long format
# alias sl='ls'
# alias l='ls'

alias ls='eza --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias ll='eza -alfh --icons --color=always --group-directories-first'
alias sl='eza --icons --color=always --group-directories-first'
alias l='eza --icons --color=always --group-directories-first'


alias lazy='NVIM_APPNAME=LazyVim nvim'
alias chad='NVIM_APPNAME=NvChad nvim'
alias neovim='NVIM_APPNAME=Neovim nvim'
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

alias cp 'advcp -g'
alias mv 'advmv -g'
# alias rm 'trash -v'

# tree alias
alias tree="eza --tree --icons"

# Neovim
alias v='nvim'
alias nv='neovide'
alias vim='nvim'

alias nf='neofetch'
alias ff='fastfetch'
alias fpc='php ~/Projects/php/flutter-project-creator/main.php'
alias cd='z'

# Fixing my brain
alias cls='clear'
alias clera='clear'
alias celar='clear'
alias lear='clear'
alias lera='clear'
alias lare='clear'
alias cleare='clear'
alias cler='clear'
alias clar='clear'

alias install='yay -S --needed'
alias s='yay -Ss'

# git helpers
alias ga='git add'
alias gap='git add --patch'
alias gc='git commit'

alias gp='git push'
alias gu='git pull'

alias gi='git init'
alias gcl='git clone'

alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n' "

alias gb='git branch'

alias gs='git status --short'
alias wip='git add . && git commit -m "wip" && git push'

# laravel helpers
alias hey='php artisan'
alias run='composer run dev'
alias mfs='php artisan migrate:fresh --seed'

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
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'          # List amount of -git packages
# list of AUR packages
alias listaur="sudo pacman -Qqem"
#Switch to gdm
alias togdm="sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo 'Gdm is active - reboot now'"

alias tosddm="sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo 'SDDM is active - reboot now'"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
