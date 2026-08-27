#!/usr/bin/env bash
# POSIX Symlink Automator for 3-Layer Dotfiles Architecture (macOS & Linux)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOSTNAME="$(hostname -s 2>/dev/null || hostname)"

echo "=== Dotfiles Repository: $DOTFILES_DIR ==="

link_file() {
  local src="$1"
  local target="$2"

  if [ ! -e "$src" ]; then
    echo "⚠️  Source path missing: $src"
    return
  fi

  mkdir -p "$(dirname "$target")"

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "🔄 Backing up existing $target -> ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -sf "$src" "$target"
  echo "✅ Linked: $target -> $src"
}

echo ""
echo "--- Layer 1: Common Dotfiles ---"
link_file "$DOTFILES_DIR/common/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/common/.ideavimrc" "$HOME/.ideavimrc"
link_file "$DOTFILES_DIR/common/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/common/nvim/vscode.lua" "$HOME/.config/nvim/vscode.lua"

echo ""
echo "--- Layer 2: OS-Specific Dotfiles ---"
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Platform: macOS"
  link_file "$DOTFILES_DIR/os/macos/.zshrc" "$HOME/.zshrc"
else
  echo "Platform: Linux"
  link_file "$DOTFILES_DIR/os/linux/.zshrc" "$HOME/.zshrc"
fi

echo ""
echo "--- Layer 3: Host-Specific Overrides ($HOSTNAME) ---"
HOST_DIR="$DOTFILES_DIR/hosts/$HOSTNAME"
if [ -d "$HOST_DIR" ]; then
  echo "Found host config at: $HOST_DIR"
else
  echo "No host directory found at: $HOST_DIR (skipping)"
fi

echo ""
echo "🎉 Symlink installation complete!"
