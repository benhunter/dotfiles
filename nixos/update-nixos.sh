#!/usr/bin/env zsh

nix flake check &&
nix flake update &&
sudo cp -r ~/projects/dotfiles/nixos/* /etc/nixos/ &&
nix-collect-garbage -d &&
sudo nixos-rebuild switch
#sudo nixos-rebuild switch --upgrade
