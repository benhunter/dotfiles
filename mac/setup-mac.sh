#!/bin/sh

mv $HOME/.zshrc $HOME/.zshrc.bak
cp ./.zshrc $HOME/
mkdir $HOME/bin
ln -s $HOME/projects/scripts/*.sh $HOME/bin
ln -s $HOME/projects/secrets/.secrets.zshrc $HOME/.secrets.zshrc
ln -s $HOME/projects/dotfiles/mac/.ideavimrc $HOME/.ideavimrc

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull
