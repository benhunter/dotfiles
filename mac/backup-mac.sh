#!/bin/sh

set +x

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
echo "Script Directory: $SCRIPT_DIR"

echo "Dumping brew..."
brew bundle dump --file=$SCRIPT_DIR/Brewfile --force

# Neovim and NvChad backup
echo "TODO git commit changes to ~/.config/nvim repo"
#echo "Copying Neovim NvChad config..."
#cp "$HOME/.config/nvim/init.lua" "$SCRIPT_DIR/.config/nvim/init.lua"
# cp -r ~/.config/nvim/lua/custom/ $SCRIPT_DIR/.config/nvim/lua/custom/
#rsync -av --exclude='.git' ~/.config/nvim/lua/custom/ $SCRIPT_DIR/.config/nvim/lua/custom/

# Update git repo
git -C $SCRIPT_DIR switch main

# if pull fails, exit
if ! git -C $SCRIPT_DIR pull; then
  echo "Pull failed. Exiting..."
  exit 1
fi

git -C $SCRIPT_DIR add -A
git -C $SCRIPT_DIR commit -v
git -C $SCRIPT_DIR push
