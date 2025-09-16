# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="robbyrussell"
#source ~/powerlevel10k/powerlevel10k.zsh-theme

# Load the .zshrc unique to this host
ZSHRC_HOSTNAME="$HOME/.zshrc.$(hostname)"
if [[ -f "$ZSHRC_HOSTNAME" ]]; then
  source "$ZSHRC_HOSTNAME"
fi

plugins=(
  git
  zsh-autosuggestions
  $ZSH_PLUGINS_EXTRA
	)

source $ZSH/oh-my-zsh.sh

# Neovim for git, etc
export EDITOR=nvim
export VISUAL=$EDITOR


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# fnm
FNM_PATH="/home/$USER/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/$USER/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# fd
export PATH="/home/$USER/.local/bin:$PATH"

# 2024-02 AOS MCSO
# Project 1
# export PATH="$HOME/projects/aos_pintos/src/utils/:$PATH"
# Project 2
# export PATH="$HOME/projects/aos_pintos_project_2/aos_pintos/src/utils:$PATH"
# Project 3
# export PATH="$HOME/projects/aos_pintos_project_3/src/utils:$PATH"
# Project 4
# export PATH="$HOME/projects/aos_pintos_project_4/src/utils:$PATH"

source $HOME/projects/dotfiles/ubuntu/helpers.sh

# fzf
# installed:
# sudo apt install fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Scripts
export PATH="/home/$USER/projects/dotfiles/ubuntu/:$PATH"

# Disk usage
alias dush='du -sh * 2> /dev/null | sort -rh'

# go - installed binaries
export PATH="/usr/local/go/bin:$PATH"

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# direnv hook
eval "$(direnv hook zsh)"

# moar as pager
export PAGER=$(which moor)

# 2024-11-28 MCSO PS Lab 5
alias mr="make && make run"

# atuin Shell History
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

. "$HOME/.cargo/env"

alias gs=gst
alias nv=nvim

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load secrets
source $HOME/.secrets.zshrc

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
