#!/bin/sh
#
# Bootstrap Xubuntu dotfiles directly from wget or curl without git clone first.
#
# wget -qO- https://raw.githubusercontent.com/benhunter/dotfiles/main/xubuntu/bootstrap-xubuntu.sh | bash
# 
# or, if curl is installed
# curl -fsSL https://raw.githubusercontent.com/benhunter/dotfiles/main/xubuntu/bootstrap-xubuntu.sh | bash
# 
# Assumptions:
# - Xubuntu is installed
# - User is logged in
# - User has sudo privileges
# - User has internet access
# - User has wget (or curl) installed
# - setup-xubuntu.sh can be run from anywhere, multiple times

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo "Updating sudoers..."
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if [ ! -f /etc/sudoers/sudoers.d/user ];
then 
    # if $LINE is not in /etc/sudoers.d/user
    if ! sudo grep -qF "$LINE" /etc/sudoers.d/user;
    then
        echo $LINE | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/user')
    fi;
fi;

echo "Updating apt..."
sudo DEBIAN_FRONTEND=noninteractive apt update
echo "Upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "Full-upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y

echo "Installing git + curl..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y git curl

echo "Cloning dotfiles..."
mkdir -p $HOME/projects/dotfiles
git clone https://www.github.com/benhunter/dotfiles.git $HOME/projects/dotfiles

echo "Running setup-xubuntu.sh..."
$HOME/projects/dotfiles/xubuntu/setup-xubuntu.sh
