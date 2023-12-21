# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.
export HISTSIZE=1000000000
ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  git
  docker
  kubectl
  helm
  zsh-autosuggestions
  ripgrep
  fd
  fzf
)

source $ZSH/oh-my-zsh.sh

source ~/.secrets.zshrc

# Open DBeaver installed by Homebrew without admin permissions
alias dbeaver="open /usr/local/Caskroom/dbeaver-community/21.2.1/DBeaver.app"

alias hollywood="docker run --rm -it bcbcarl/hollywood" # Hollywood CLI

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/mysql/bin" # MySql
export PATH="/usr/local/opt/openssl/bin:$PATH" # OpenSSL
export PATH="/usr/local/opt/libpq/bin:$PATH" # PostgreSQL, psql, pg_dump, pg_restore

alias l='lsd -a' # lsd https://github.com/Peltoche/lsd
alias ls='lsd'
alias ll='lsd -lah'
alias cat='bat'
alias mkd='mkdir -p'
alias dcp='docker-compose'
alias dus='du -hs * | sort -hr'
alias dusa='setopt nullglob; du -hs .[^.]* * | sort -hr'
alias watch1='watch -n 1'
alias rmrf='rm -rf'
alias gs=gst
alias ch='curl cht.sh'
alias nv='nvim'
alias n='nvim'
alias gp='git push && git push --tags'
alias gpt='git push --tags'
alias gpot='git push origin --tags'
alias bfg='java -jar ~/bin/bfg.jar'
alias datestamp-local='date +%Y-%m-%d-%H%M%S'
alias datestamp='date -u +%Y-%m-%dT%H:%M'

glab-ci-run() {
  glab ci run -b "$(git rev-parse --abbrev-ref HEAD)"
}

# Java JDK Version
alias j19="export JAVA_HOME=`/usr/libexec/java_home -v 19`; java --version"
alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java --version"
alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java --version"
alias j11-quiet="export JAVA_HOME=`/usr/libexec/java_home -v 11`"

# Neovim for git, etc
export EDITOR=nvim
export VISUAL=$EDITOR

# gpg
export GPG_TTY=$(tty)

# Node
export NODE_EXTRA_CA_CERTS="$HOME/.certs/DigiCert-High-Assurance-EV-Root-CA.pem"

# Puppeteer arm64 for Destreamer (https://github.com/snobu/destreamer)
export PUPPETEER_EXECUTABLE_PATH=`which chromium`
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Commands
j17  # set Java 17 as default
# brew outdated  # list brews that need updates. This slows down opening zsh...
eval "$(direnv hook zsh)" # direnv hook
eval "$(fnm env --use-on-cd)" # fnm - Fast node manager

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Adds shortcuts:
# CTRL-t	Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT.
# ALT-c	Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
# CTRL-r	Fuzzy find through your shell history, and output the selection to STDOUT.

# gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk && \
  export PATH=$PATH:$ANDROID_HOME/emulator && \
  export PATH=$PATH:$ANDROID_HOME/platform-tools
