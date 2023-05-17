#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# .zshrc
mv $HOME/.zshrc $HOME/.zshrc.bak
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -s $HOME/projects/secrets/.secrets.zshrc $HOME/.secrets.zshrc

# Scripts
mkdir $HOME/bin
ln -s $HOME/projects/scripts/*.sh $HOME/bin

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

# Misc
ln -s $SCRIPT_DIR/.ideavimrc $HOME/.ideavimrc
brew upgrade
