# Replace ls with eza
alias ls='lsd' # preferred listing
alias la='ls -a'  # all files and dirs
alias ll='ls -alFh'  # long format
alias sl='ls'
alias l='ls'

alias cp 'advcp -g'
alias mv 'advmv -g'

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

# git helpers
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gs='git status --short'
alias wip='git add . && git commit -m "wip" && git push'

# laravel helpers
alias hey='php artisan'
alias run='composer run dev'

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


# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
