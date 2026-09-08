#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

echo "Installing Podman..."
"$SCRIPT_DIR/install-podman.sh"

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# shellcheck source=/dev/null disable=SC1091
source "$HOME/.cargo/env"

echo "Installing build tools (gcc)..."
install_apt build-essential

echo "Installing topgrade..."
cargo install topgrade

echo "Running Uptime Kuma..."
podman run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma docker.io/louislam/uptime-kuma:2
