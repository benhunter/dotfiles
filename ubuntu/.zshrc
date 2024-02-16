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


plugins=(
	git 
	zsh-autosuggestions
	)

source $ZSH/oh-my-zsh.sh

# Neovim for git, etc
export EDITOR=nvim
export VISUAL=$EDITOR


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias gs=gst

# fnm
export PATH="/home/ben/.local/share/fnm:$PATH"
eval "`fnm env`"
