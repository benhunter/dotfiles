# TODO direnv not found

has() { command -v "$1" >/dev/null 2>&1; }

# TODO setup-ubuntu.sh not found when this script is run from another folder.
./../ubuntu/setup-ubuntu.sh

# Homebrew
# https://brew.sh/
if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Docker permissions
sudo usermod -aG docker $USER
newgrp docker
