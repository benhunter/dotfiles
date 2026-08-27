# Host Zsh configuration for LAST
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
