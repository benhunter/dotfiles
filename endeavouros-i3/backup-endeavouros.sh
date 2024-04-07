#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

source $SCRIPT_DIR/../scripts/functions.sh

cp ~/.Xresources "$SCRIPT_DIR"
cp ~/.xinitrc "$SCRIPT_DIR"
cp -r ~/.config/fontconfig "$SCRIPT_DIR/.config/"
cp -r ~/.config/i3/ "$SCRIPT_DIR/.config/"
cp ~/.ssh/config "$SCRIPT_DIR/.ssh/config"

git_commit
