#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "Done"; exit 0 # TODO remove

# TODO only chsh if needed
# chsh -s $(which zsh)
#
# TODO install Atuin https://atuin.sh/

# Install pacman packages.
echo "Installing: pacman packages..."
yay --noconfirm --answerdiff=None --answeredit=None
# Alternative to yay:
#   sudo pacman -Syu # Always run before installing packages.
for x in $(cat "$SCRIPT_DIR/pacman/pacman-packages.txt"); do 
  echo "  Installing: $x"
  yay -S --needed $x
done

# .zshrc
echo "Backing up and linking .zshrc..."
# TODO does .bak exist?
if [ ! -f "$HOME/.zshrc.bak"]; then
  echo "Backing up .zshrc"
  mv $HOME/.zshrc $HOME/.zshrc.bak
else
  echo "Could not back up .zshrc, found a .zshrc.bak"
  echo "Error: stopping setup"
  exit 1
fi

echo "Linking ~/.zshrc"
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc

echo "Linking .gitconfig..."
ln -s $SCRIPT_DIR/.gitconfig $HOME/.gitconfig

# Tmux
echo "Linking .tmux.conf..."
ln -s $SCRIPT_DIR/../.tmux.conf $HOME/.tmux.conf
echo "Installing Tmux plugins..."
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
$HOME/.tmux/plugins/tpm/bin/update_plugins all
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"

# Rust
if ! type "cargo" &> /dev/null; then
  echo "Installing: Rust, cargo"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "Skipping install: Rust, cargo"
fi

# bottom
if ! type "btm" &> /dev/null; then
  echo "Installing: bottom"
  cargo install bottom --locked
else
  echo "Skipping install: bottom"
fi

COMMAND='cargo nextest'
if ! type "$COMMAND" &> /dev/null; then
  echo "Installing: cargo-nextest"
  cargo install cargo-nextest --locked
else
  echo "Skipping install: cargo-nextest"
fi

COMMAND='cargo watch'
if ! type "$COMMAND" &> /dev/null; then
  echo "Installing: cargo-watch"
  cargo install cargo-watch
else
  echo "Skipping install: cargo-watch"
fi

COMMAND='fnm'
if ! type "$COMMAND" &> /dev/null; then
  echo "Installing: Fast Node Manager, fnm"
  cargo install fnm
else
  echo "Skipping install: Fast Node Manager, fnm"
fi

## NvChad
## https://nvchad.com/docs/quickstart/install
if [ ! -f ~/.config/nvim/init.lua ]; then
  echo "Installing NvChad..."
  git clone https://github.com/benhunter/nvchad-config ~/.config/nvim && nvim
  echo -e "!!\n!!\n!!  To finish NvChad config, run MasonInstallAll\n!!\n!!\n!!"
else
  echo "Skipping install: NvChad"

# fd
echo "Linking fdfind to fd..."
# mkdir -p ~/.local/bin
# TODO ln -s $(which fdfind) ~/.local/bin/fd

# Screen Backlight
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
echo "Tailscale installed. To finish setup, run \'sudo tailscale up\'"

echo "Reminders:"
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll\n!!\n!!\n!!"
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
