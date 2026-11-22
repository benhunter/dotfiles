#!/bin/sh
#
# Pi https://pi.dev/

# Script setup
set -e
set -o pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
. "$SCRIPT_DIR/scripts/functions.sh" || exit 1

# Prerequisites
if ! has fnm; then
  echo "fnm not found. Install fnm..."
  exit 1
fi

if ! has node; then
  echo "node not found. Install node with fnm..."
  exit 1
fi

# Install
curl -fsSL https://pi.dev/install.sh | sh

# Config for pi.dev harness

# Extensions
#pi install npm:@amaster.ai/pi-attachments # https://pi.dev/packages/@amaster.ai/pi-attachments
#pi install npm:pi-cmd-expand
pi install npm:@fgladisch/pi-zsh-shell # https://pi.dev/packages/@fgladisch/pi-zsh-shell

# Future extensions to test
# - https://pi.dev/packages/pi-zsh-bang-complete
# - https://pi.dev/packages/@diegopetrucci/pi-inline-bash
