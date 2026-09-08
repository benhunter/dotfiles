#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

# Check if cargo is installed
COMMAND='cargo'
if ! has "$COMMAND"; then
  echo "Error: cargo is not installed. Please install Rust and Cargo first."
  exit 1
fi

# Check if cargo-watch is installed by verifying its version output
if cargo watch --version >/dev/null 2>&1; then
  echo "Skipping install: cargo-watch is already installed."
else
  echo "Installing: cargo-watch"
  cargo install cargo-watch
fi
