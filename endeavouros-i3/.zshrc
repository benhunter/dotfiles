# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#ZSH_THEME=""
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="powerlevel10k/powerlevel10k"
#source ~/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

plugins=(
	git 
  rust
  ripgrep
  tmux
  docker
  docker-compose
  zsh-autosuggestions
	)

source /usr/share/oh-my-zsh/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Neovim for git, etc
export EDITOR=nvim
export VISUAL=$EDITOR

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias gs=gst

# fnm
export PATH="/home/ben/.local/share/fnm:$PATH"
# TODO eval "`fnm env`"

# fd
export PATH="/home/ben/.local/bin:$PATH"

# fzf
# installed:
# sudo apt install fzf
# TODO source /usr/share/doc/fzf/examples/key-bindings.zsh
# TODO source /usr/share/doc/fzf/examples/completion.zsh
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

alias l="ls -a"
alias ll="ls -alh"

# Dotfiles Scripts
export PATH="$HOME/projects/dotfiles/endeavouros-i3:$PATH"

# Rust
. "$HOME/.cargo/env"

# Fast Node Manager (fnm)
eval "$(fnm env --use-on-cd)"

eval "$(atuin init zsh)"
