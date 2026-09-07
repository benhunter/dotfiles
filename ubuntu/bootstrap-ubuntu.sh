#!/bin/sh
#
# Bootstrap Ubuntu dotfiles directly from wget or curl without git clone first.
#
# wget -qO- https://raw.githubusercontent.com/benhunter/dotfiles/main/ubuntu/bootstrap-ubuntu.sh | bash
# 
# or, if curl is installed
# curl -fsSL https://raw.githubusercontent.com/benhunter/dotfiles/main/ubuntu/bootstrap-ubuntu.sh | bash
# 
# Assumptions:
# - Ubuntu is installed
# - User is logged in
# - User has sudo privileges
# - User has internet access
# - User has wget (or curl) installed
# - setup-ubuntu.sh can be run from anywhere, multiple times

set -e

echo "Updating sudoers..."
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if ! sudo grep -qxF "$LINE" /etc/sudoers.d/user; then
    # Preserve other entries and validate before replacing the sudoers file.
    SUDOERS_TMP=$(mktemp)
    trap 'rm -f "$SUDOERS_TMP"' EXIT
    if sudo test -e /etc/sudoers.d/user; then
        # The temporary file is owned by this user; only the read needs sudo.
        # shellcheck disable=SC2024
        sudo cat /etc/sudoers.d/user > "$SUDOERS_TMP"
    fi
    printf '\n%s\n' "$LINE" >> "$SUDOERS_TMP"
    sudo visudo -cf "$SUDOERS_TMP"
    sudo install -o root -g root -m 0440 "$SUDOERS_TMP" /etc/sudoers.d/user
    rm -f "$SUDOERS_TMP"
    trap - EXIT
fi

echo "Updating apt..."
sudo DEBIAN_FRONTEND=noninteractive apt update
echo "Upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "Full-upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y

echo "Installing git + curl..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y git curl

DOTFILES_DIR="$HOME/projects/dotfiles"
if [ -d "$DOTFILES_DIR/.git" ] || [ -f "$DOTFILES_DIR/.git" ]; then
    echo "Using existing dotfiles checkout (leaving local changes untouched)..."
    git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null
elif [ -e "$DOTFILES_DIR" ] || [ -L "$DOTFILES_DIR" ]; then
    echo "Refusing to overwrite existing non-Git path: $DOTFILES_DIR" >&2
    exit 1
else
    echo "Cloning dotfiles..."
    mkdir -p "$HOME/projects"
    git clone https://www.github.com/benhunter/dotfiles.git "$DOTFILES_DIR"
fi

echo "Running setup-ubuntu.sh..."
"$DOTFILES_DIR/ubuntu/setup-ubuntu.sh"
