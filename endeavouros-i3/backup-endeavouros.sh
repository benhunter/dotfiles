#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cp ~/.Xresources "$SCRIPT_DIR"
cp ~/.xinitrc "$SCRIPT_DIR"
