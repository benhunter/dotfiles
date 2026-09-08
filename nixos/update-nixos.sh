#!/bin/sh

set -eu

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

nix flake update
nix flake check
hydra-check --channel 26.05
hydra-check bottles --channel 26.05

host=$(hostname)
# nix flake show --json | jq -e --arg host "$host" '.nixosConfigurations[$host]' >/dev/null
sudo nixos-rebuild switch --flake ".#$host"

# nix-collect-garbage -d
