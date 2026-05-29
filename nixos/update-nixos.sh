#!/usr/bin/env zsh

set -euo pipefail

script_dir=${0:a:h}
cd "$script_dir"

nix flake update
nix flake check

# nix flake show --json | jq -e --arg host "$host" '.nixosConfigurations[$host]' >/dev/null

host=$(hostname)
sudo nixos-rebuild switch --flake ".#$host"

# nix-collect-garbage -d
