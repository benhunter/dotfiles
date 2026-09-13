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
if [[ -r "$ZSHRC_HOSTNAME" ]]; then
  source "$ZSHRC_HOSTNAME"
fi

plugins=(
  git
  zsh-autosuggestions
  $ZSH_PLUGINS_EXTRA
	)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Neovim for git, etc
export EDITOR=nvim
export VISUAL=$EDITOR

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
fi
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell zsh)"
fi

# fzf
# installed:
# sudo apt install fzf
if command -v fzf >/dev/null 2>&1; then
  [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
fi

# Scripts and tools
[[ -r "$HOME/projects/dotfiles/ubuntu/helpers.sh" ]] && source "$HOME/projects/dotfiles/ubuntu/helpers.sh"
export PATH="$HOME/projects/dotfiles/ubuntu/:$PATH"
export PATH="$HOME/projects/scripts/:$PATH"
export PATH="$HOME/.local/bin:$PATH" # fd, uv, uvx

# Aliases
alias dush='du -sh * 2> /dev/null | sort -rh'
alias dusha='du -sh *(D) 2>/dev/null | sort -rh'
alias gs=gst
alias nv=nvim
alias dcp='docker compose'
alias watch1='watch -n 1 -d -c '
alias mr="make && make run"
alias tmuxa="tmux a || tmux"
alias watch1='watch -n 1 -d -c '


# Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
# TODO redundant?
export PATH="/usr/local/go/bin:$PATH" # go - installed binaries

# direnv hook
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Prefer moor when installed; otherwise preserve the user's pager.
if command -v moor >/dev/null 2>&1; then
  export PAGER="$(command -v moor)"
else
  export PAGER="${PAGER:-less}"
fi

# atuin Shell History
[[ -r "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load secrets
[[ -r "$HOME/.secrets.zshrc" ]] && source "$HOME/.secrets.zshrc"

# Homebrew
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# bun
[[ -r "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun" # bun completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add deno completions to search path
if [[ -d "$HOME/.zsh/completions" && ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

[[ -r "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

export PAI_DIR="$HOME/.codex/"

# 2026-01 PAI Configuration (added by Kai Bundle installer) 
# https://github.com/benhunter/Personal_AI_Infrastructure
export DA="Dash"
export TIME_ZONE="CST"
export PAI_SOURCE_APP="$DA"

# Pi 2026-09-06
# TODO does fnm add its bin to PATH automatically?
#export PATH="$HOME/.local/share/fnm/node-versions/v24.3.0/installation/bin:$PATH"
