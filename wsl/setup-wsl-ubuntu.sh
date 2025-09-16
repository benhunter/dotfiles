# TODO direnv not found

has() { command -v "$1" >/dev/null 2>&1; }

# TODO setup-ubuntu.sh not found when this script is run from another folder.
./../ubuntu/setup-ubuntu.sh

../linux/install-homebrew.sh

# k9s
if ! has k9s; then
  brew install derailed/k9s/k9s
fi

# Docker permissions
sudo usermod -aG docker $USER
newgrp docker
