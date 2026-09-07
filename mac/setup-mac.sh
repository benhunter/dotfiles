#!/usr/bin/env bash

set -e
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# Never overwrite an earlier backup, including a dangling symlink.
backup_path() {
  local target="$1" backup="$1.bak" n=1
  if [[ -e "$target" || -L "$target" ]]; then
    while [[ -e "$backup" || -L "$backup" ]]; do
      backup="$target.bak.$n"
      n=$((n + 1))
    done
    mv -- "$target" "$backup"
  fi
}

link_file() {
  local source="$1" target="$2"
  if [[ ! -e "$source" && ! -L "$source" ]]; then
    echo "Skipping missing source: $source"
    return
  fi
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  ln -s "$source" "$target"
}

copy_file() {
  local source="$1" target="$2"
  if [[ ! -f "$source" ]]; then
    echo "Skipping missing source: $source"
    return
  fi
  if [[ -f "$target" ]] && cmp -s "$source" "$target"; then
    return
  fi
  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  cp "$source" "$target"
}

ensure_repo() {
  local url="$1" target="$2"
  if [[ -d "$target/.git" || -f "$target/.git" ]]; then
    echo "Using existing checkout: $target"
    git -C "$target" rev-parse --is-inside-work-tree >/dev/null
  elif [[ -e "$target" || -L "$target" ]]; then
    echo "Refusing to overwrite non-Git path: $target" >&2
    return 1
  else
    mkdir -p "$(dirname "$target")"
    git clone --depth=1 "$url" "$target"
  fi
}

# Homebrew may already be installed but absent from this shell's PATH.
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi
brew bundle install --file="$SCRIPT_DIR/Brewfile"

# Install before linking .zshrc, without replacing it or launching a shell.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
link_file "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
link_file "$HOME/projects/secrets/.secrets.zshrc" "$HOME/.secrets.zshrc"
link_file "$SCRIPT_DIR/env" "$HOME/env"

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ensure_repo https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
copy_file "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ensure_repo https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"

# Ignore unmatched globs rather than creating literal '*.sh' links.
shopt -s nullglob
mkdir -p "$HOME/bin"
for source in "$SCRIPT_DIR"/bin/* "$HOME/projects/scripts"/*.sh "$SCRIPT_DIR"/*.sh "$HOME/scripts"/*.sh; do
  link_file "$source" "$HOME/bin/$(basename "$source")"
done

# Tmux
echo "Configuring tmux..."
link_file "$SCRIPT_DIR/../.tmux.conf" "$HOME/.tmux.conf"
link_file "$SCRIPT_DIR/../.tmux.local.conf" "$HOME/.tmux.local.conf"
ensure_repo https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all

# Git
echo "Configuring git..."
copy_file "$SCRIPT_DIR/.gitignore_global" "$HOME/.gitignore_global"
link_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
git config --global core.excludesfile "$HOME/.gitignore_global"

# Copy the contents, not the directory, to avoid nested .pandoc directories.
if [[ -d "$SCRIPT_DIR/.pandoc" ]]; then
  mkdir -p "$HOME/.pandoc"
  cp -R "$SCRIPT_DIR/.pandoc/." "$HOME/.pandoc/"
fi

# Rust Programming Language
if ! command -v rustup >/dev/null 2>&1 && [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# NvChad: preserve existing configurations, including non-Git ones.
if [[ ! -e "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  ensure_repo https://github.com/benhunter/nvchad-config "$HOME/.config/nvim"
  echo "To finish NvChad config, open nvim and run MasonInstallAll"
else
  echo "Keeping existing Neovim configuration"
fi

# SDKMAN https://sdkman.io/
if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  curl -fsSL "https://get.sdkman.io" | bash
fi
copy_file "$SCRIPT_DIR/.sdkman/etc/config" "$HOME/.sdkman/etc/config"

# Misc
link_file "$SCRIPT_DIR/.ideavimrc" "$HOME/.ideavimrc"

# Updates are deliberately run each time.
echo "Running update-mac.sh..."
"$SCRIPT_DIR/update-mac.sh"
