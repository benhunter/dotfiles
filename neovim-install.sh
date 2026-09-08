#!/bin/sh
# Install Neovim from nightly

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/scripts/functions.sh" || exit 1

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
install_apt neovim python3-pip fonts-powerline ripgrep fd-find

# pynvim
pip install pynvim --upgrade

# fnm - Fast Node Manager and Node 18
curl -fsSL https://fnm.vercel.app/install | bash
fnm install 18

# Node packages
npm install -g neovim tree-sitter-cli
