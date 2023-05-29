#!/bin/sh

set +x

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
echo "Script Directory: $SCRIPT_DIR"

echo "Dumping brew..."
brew bundle dump --file=$SCRIPT_DIR/Brewfile

echo "Copying Neovim NvChad config..."
cp -r ~/.config/nvim/lua/custom/ $SCRIPT_DIR/.config/nvim/lua/custom/

git add -A
git commit -v
