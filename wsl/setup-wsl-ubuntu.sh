# TODO direnv not found

# TODO setup-ubuntu.sh not found when this script is run from another folder.
./../ubuntu/setup-ubuntu.sh

# Homebrew
# https://brew.sh/
# TODO skip if homebrew is already installed.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Docker permissions
sudo usermod -aG docker $USER
newgrp docker
