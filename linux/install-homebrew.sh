#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

# Homebrew
# https://brew.sh/
if ! has brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
