#!/bin/sh

set +x

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
echo "Script Directory: $SCRIPT_DIR"

echo "Copying .gitconfig"
cp ~/.gitconfig $SCRIPT_DIR/

# Update git repo
git -C $SCRIPT_DIR switch main

# if pull fails, exit
if ! git -C $SCRIPT_DIR pull; then
  echo "Pull failed. Exiting..."
  exit 1
fi

git -C $SCRIPT_DIR add -A
git -C $SCRIPT_DIR commit -v
git -C $SCRIPT_DIR push
