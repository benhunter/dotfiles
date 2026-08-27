# Common Shell Aliases (Layer 1)

# Git Aliases
alias gs='git status -sb'
alias gst='git status'
alias ga='git add'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'

# Editor
alias nv='nvim'
alias v='vim'

# Utilities & Disk Usage
alias dcp='docker compose'
alias dush='du -sh * 2> /dev/null | sort -rh'
alias dusha='du -sh *(D) 2>/dev/null | sort -rh'
alias watch1='watch -n 1 -d -c '
alias mr='make && make run'

# Kubernetes
alias k=kubectl
alias kns=kubens