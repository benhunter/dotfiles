# TODO direnv not found

has() { command -v "$1" >/dev/null 2>&1; }
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

$SCRIPT_DIR/../ubuntu/setup-ubuntu.sh

$SCRIPT_DIR/../linux/install-homebrew.sh

# k9s
if ! has k9s; then
  brew install derailed/k9s/k9s
fi

# github cli
if ! has gh; then
  brew install gh
fi

# Docker permissions
sudo usermod -aG docker $USER
newgrp docker
