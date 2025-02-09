#!/bin/bash

# Setup my tools and dotfiles.
# 2022-08-07

# Prerequisites:
# sudo apt install git
# alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# git clone --separate-git-dir ~/.dotfiles https://github.com/benhunter/dotfiles-ubuntu ~/.dotfiles-tmp
# config config --local status.showUntrackedFiles no
# rm -rf ~/.dotfiles-tmp
# config reset --hard
# source ~/.bashrc
# sudo ~/install.sh

# - [ ] make the prereqs a script to wget/curl and run
# - [ ] lsd
# - [ ] bat


sudo apt-get update &&
sudo apt-get -y upgrade &&

# if installing in VMWare Workstation in a desktop environment
sudo apt install open-vm-tools-desktop
# sudo apt-get -y install open-vm-tools  # VMWare tools without desktop

# tmux
sudo apt-get -y install tmux curl pass

# neovim
sudo ./install-neovim.sh

# Setup Git
git config --global user.email "code@benhunter.me"
git config --global user.name "Ben Hunter"


# Git Credential Manager
# https://github.com/GitCredentialManager/git-credential-manager
# Requires curl and pass
curl -L https://raw.githubusercontent.com/GitCredentialManager/git-credential-manager/main/src/linux/Packaging.Linux/install-from-source.sh -o /tmp/gcm-install.sh &&
sh /tmp/gcm-install.sh -y &&
git-credential-manager-core configure

# Setup GPG key
echo "Download GPG key to public_key.txt and private_key.txt"
echo "Import key with:"
echo "gpg --import ~/public_key.txt"
echo "gpg --allow-secret-key-import --import ~/private_key.txt"
echo ""

# Setup pass
echo "To setup pass, run:"
echo "gpg --list-keys"
echo "pass init <gpg-id>"
echo ""


