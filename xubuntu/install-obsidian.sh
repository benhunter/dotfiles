#!/bin/sh
#
# Obsidian

OBSIDIAN_VERSION="1.7.7"
mkdir $HOME/bin

curl -L -o "$HOME/bin/Obsidian-$OBSIDIAN_VERSION.AppImage" "https://github.com/obsidianmd/obsidian-releases/releases/download/v$OBSIDIAN_VERSION/Obsidian-$OBSIDIAN_VERSION.AppImage"

chmod u+x $HOME/bin/Obsidian-${OBSIDIAN_VERSION}.AppImage
