#!/bin/bash

has() { command -v "$1" >/dev/null 2>&1; }

# Homebrew
# https://brew.sh/
if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
