#!/usr/bin/env zsh
nix flake update
sudo cp -r ~/projects/dotfiles/nixos/* /etc/nixos/ && sudo nixos-rebuild switch
