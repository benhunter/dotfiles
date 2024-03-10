#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cp ~/.Xresources "$SCRIPT_DIR/.Xresources"
cp ~/.xinitrc "$SCRIPT_DIR/.xinitrc"
