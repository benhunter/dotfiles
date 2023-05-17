#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo "Dumping brew..."
brew bundle dump -f > $SCRIPT_DIR/Brewfile
