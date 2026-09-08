#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

# SDKMAN
curl -s "https://get.sdkman.io" | bash
# shellcheck source=/dev/null disable=SC1091
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Atuin config
mkdir -p "$HOME/.config/atuin"
cp "$SCRIPT_DIR/.config/atuin/config.toml" "$HOME/.config/atuin/"

# TODO only chsh if needed
# chsh -s $(which zsh)
#
# TODO install Atuin https://atuin.sh/

# Install pacman packages.
echo "Installing: pacman packages..."
yay --noconfirm --answerdiff=None --answeredit=None
# Alternative to yay:
#   sudo pacman -Syu # Always run before installing packages.
while IFS= read -r x <&3 || [ -n "$x" ]; do
  [ -z "$x" ] && continue
  echo "  Installing: $x"
  yay -S --needed "$x"
done 3< "$SCRIPT_DIR/pacman/pacman-packages.txt"

# .zshrc
echo "Backing up and linking .zshrc..."
link_file "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

echo "Linking .gitconfig..."
link_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

# Tmux
echo "Linking .tmux.conf..."
link_file "$SCRIPT_DIR/../.tmux.conf" "$HOME/.tmux.conf"
echo "Installing Tmux plugins..."
ensure_repo https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"

# Rust
if ! has cargo; then
  echo "Installing: Rust, cargo"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck source=/dev/null disable=SC1091
  source "$HOME/.cargo/env"
else
  echo "Skipping install: Rust, cargo"
fi

# bottom
if ! has btm; then
  echo "Installing: bottom"
  cargo install bottom --locked
else
  echo "Skipping install: bottom"
fi

if ! cargo nextest --version >/dev/null 2>&1; then
  echo "Installing: cargo-nextest"
  cargo install cargo-nextest --locked
else
  echo "Skipping install: cargo-nextest"
fi

if ! cargo watch --version >/dev/null 2>&1; then
  echo "Installing: cargo-watch"
  cargo install cargo-watch
else
  echo "Skipping install: cargo-watch"
fi

if ! has fnm; then
  echo "Installing: Fast Node Manager, fnm"
  cargo install fnm
else
  echo "Skipping install: Fast Node Manager, fnm"
fi

## NvChad
## https://nvchad.com/docs/quickstart/install
if [ ! -f ~/.config/nvim/init.lua ]; then
  echo "Installing NvChad..."
  ensure_repo https://github.com/benhunter/nvchad-config "$HOME/.config/nvim" && nvim
  echo -e "!!\n!!\n!!  To finish NvChad config, run MasonInstallAll\n!!\n!!\n!!"
else
  echo "Skipping install: NvChad"
fi

# fd
echo "Linking fdfind to fd..."
# mkdir -p ~/.local/bin
# TODO ln -s $(which fdfind) ~/.local/bin/fd

# Screen Backlight Brightness
# https://gitlab.com/wavexx/acpilight
# https://wiki.archlinux.org/title/backlight#Backlight_utilities
sudo pacman -S acpilight

# Hack Nerd Font
sudo pacman -S ttf-hack-nerd

sudo pacman -S ripgrep
sudo pacman -S just
sudo pacman -S noto-fonts-emoji
sudo pacman -S xclip # allows Neovim to yank to system clipboard
sudo pacman -S texlive-basic texlive-latex texlive-formatsextra texlive-latexrecommended extra/texlive-latexextra # pdflatex
sudo pacman -S protobuf # protoc Protocol Buffers Compiler
sudo pacman -S signal-desktop # Signal messenger app. https://signal.org
sudo pacman -S mupdf

# Catppuccin
# xfce4-terminal theme https://github.com/catppuccin/xfce4-terminal/blob/main/src/catppuccin-mocha.theme

# Setup external display (Viotek ultrawide in office)
# https://lecorbeausvault.wordpress.com/2021/09/25/using-xrandr-for-multi-monitor-setups-plus-some-useful-scripts/
#
# xrandr --output eDP1 --primary --mode 2560x1440 --output DP2-3 --mode 3440x1440 --right-of eDP1

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
echo "Tailscale installed. To finish setup, run 'sudo tailscale up'"

echo "Reminders:"
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll\n!!\n!!\n!!"
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
