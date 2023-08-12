# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

# User configuration

source ~/.secrets.zshrc

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

glab-ci-run() {
  glab ci run -b "$(git rev-parse --abbrev-ref HEAD)"
}

# Java JDK Version
alias j19="export JAVA_HOME=`/usr/libexec/java_home -v 19`; java --version"
alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java --version"
alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java --version"
alias j11-quiet="export JAVA_HOME=`/usr/libexec/java_home -v 11`"

# zsh
export HISTSIZE=1000000000

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
j11-quiet  # set Java 11 as default
# brew outdated  # list brews that need updates
eval "$(direnv hook zsh)" # direnv hook
eval "$(fnm env --use-on-cd)" # fnm - Fast node manager

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Adds shortcuts:
# CTRL-t	Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT.
# ALT-c	Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
# CTRL-r	Fuzzy find through your shell history, and output the selection to STDOUT.
