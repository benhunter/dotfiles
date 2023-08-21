#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# .zshrc
mv $HOME/.zshrc $HOME/.zshrc.bak
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -s $HOME/projects/secrets/.secrets.zshrc $HOME/.secrets.zshrc

ln -s $SCRIPT_DIR/env $HOME/env

# oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

# Binaries and Scripts
mkdir -p $HOME/bin
ln -s $SCRIPT_DIR/bin/* $HOME/bin
ln -s $HOME/projects/scripts/*.sh $HOME/bin
# ln -s $SCRIPT_DIR/update-mac.sh $HOME/bin/update-mac.sh
ln -s $SCRIPT_DIR/*.sh $HOME/bin/

# Tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
$HOME/.tmux/plugins/tpm/bin/update_plugins all

# Git
cp $SCRIPT_DIR/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

# Pandoc Templates
cp -r $SCRIPT_DIR/.pandoc $HOME/.pandoc

# Rust Programming Language
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Misc
ln -s $SCRIPT_DIR/.ideavimrc $HOME/.ideavimrc

# Update - Do Last
$SCRIPT_DIR/update-mac.sh
