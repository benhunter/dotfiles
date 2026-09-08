#!/bin/sh
# TODO direnv not found

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

"$SCRIPT_DIR/../ubuntu/setup-ubuntu.sh"

"$SCRIPT_DIR/../linux/install-homebrew.sh"

# k9s
if ! has k9s; then
  brew install derailed/k9s/k9s
fi

# github cli
if ! has gh; then
  brew install gh
fi

# Docker permissions
sudo usermod -aG docker "$USER"
newgrp docker
