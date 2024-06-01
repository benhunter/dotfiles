#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

source $SCRIPT_DIR/../scripts/functions.sh

cp ~/.Xresources "$SCRIPT_DIR"
cp ~/.xinitrc "$SCRIPT_DIR"
cp -r ~/.config/fontconfig "$SCRIPT_DIR/.config/"
cp -r ~/.config/i3/ "$SCRIPT_DIR/.config/"
cp ~/.ssh/config "$SCRIPT_DIR/.ssh/config"
cp -r ~/.screenlayout/ "$SCRIPT_DIR/"
cp -r ~/.config/atuin/config.toml "$SCRIPT_DIR/.config/atuin/"

pacman -Qe | awk '{print $1}' > "$SCRIPT_DIR/pacman/pacman-packages.txt" # Used for reinstall
pacman -Qe > "$SCRIPT_DIR/pacman/pacman-qe-explicitly-installed-packages.txt"
pacman -Q > "$SCRIPT_DIR/pacman/pacman-q-all-installed-packages.txt"

git_commit
