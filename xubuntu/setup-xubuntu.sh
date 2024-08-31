#!/bin/sh
#
# curl -fsSL https://raw.githubusercontent.com/benhunter/dotfiles/main/xubuntu/setup-xubuntu.sh | bash
# wget -qO- https://raw.githubusercontent.com/benhunter/dotfiles/main/xubuntu/setup-xubuntu.sh | bash
# 
# Assumptions:
# - Xubuntu is installed
# - User is logged in
# - User has sudo privileges
# - User has internet access
# - User has curl installed
# - setup-xubuntu.sh can be run from anywhere, multiple times

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# update sudoers
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if [ ! -f /etc/sudoers/sudoers.d/user ];
then 
    # if $LINE is not in /etc/sudoers.d/user
    if ! sudo grep -qF "$LINE" /etc/sudoers.d/user;
    then
        echo $LINE | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/user')
    fi;
fi;

# apt packages
echo "Updating apt..."
sudo DEBIAN_FRONTEND=noninteractive apt update
echo "Upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "Full-upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y