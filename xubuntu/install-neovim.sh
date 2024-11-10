#!/bin/sh
#
# Neovim
#
# https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
# Use unstable repo for PPA

echo "Installing Neovim..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common

UBUNTU_CODENAME=$(lsb_release -cs)

# 2024-11-10 On Xubuntu 20.10 Oracular Oriole there's no neovim/unstable package yet.
if [ "$UBUNTU_CODENAME" = "oracular" ]; then
  # Use noble instead.
  # See the packages here: https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu
  UBUNTU_NAME="noble"
  echo "deb https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu $UBUNTU_NAME main" | sudo tee /etc/apt/sources.list.d/neovim-ppa-unstable-$UBUNTU_NAME.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 55F96FCF8231B6DD
else
  sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:neovim-ppa/unstable # TODO prompts for Enter to continue.
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y neovim python3-pip fonts-powerline ripgrep fd-find
