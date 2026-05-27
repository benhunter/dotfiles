#!/usr/bin/env zsh

nix flake update &&
nix flake check &&
sudo cp -r ~/projects/dotfiles/nixos/* /etc/nixos/ &&
sudo nixos-rebuild switch &&
#sudo nixos-rebuild switch --upgrade &&
# nix-collect-garbage -d
