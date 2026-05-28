#!/usr/bin/env zsh

set -euo pipefail

cd ~/projects/dotfiles/nixos/

nix flake update
nix flake check

# Old build command
# sudo cp -r ~/projects/dotfiles/nixos/* /etc/nixos/ &&
# sudo nixos-rebuild switch
#sudo nixos-rebuild switch --upgrade &&
# nix-collect-garbage -d

# New build command
sudo nixos-rebuild switch --flake .#$(hostname)
