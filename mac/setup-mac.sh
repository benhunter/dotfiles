#!/bin/sh

mv $HOME/.zshrc $HOME/.zshrc.bak
cp ./.zshrc $HOME/
mkdir $HOME/bin
ln -s $HOME/projects/scripts/*.sh $HOME/bin
ln -s $HOME/projects/secrets/.secrets.zshrc $HOME/.secrets.zshrc

