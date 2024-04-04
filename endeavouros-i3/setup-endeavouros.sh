#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# TODO only chsh if needed
# chsh -s $(which zsh)

# .zshrc
echo "Backing up and linking .zshrc..."
mv $HOME/.zshrc $HOME/.zshrc.bak
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
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# bottom
echo "Installing bottom..."
cargo install bottom --locked

echo "Installing cargo-nextest..."
cargo install cargo-nextest --locked

echo "Installing cargo-watch..."
cargo install cargo-watch

echo "Installing Fast Node Manager (fnm)"
cargo install fnm

## NvChad
## https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
git clone https://github.com/benhunter/nvchad-config ~/.config/nvim && nvim
echo -e "!!\n!!\n!!  To finish NvChad config, run MasonInstallAll\n!!\n!!\n!!"

exit # TODO remove

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

# Catppuccin
# xfce4-terminal theme https://github.com/catppuccin/xfce4-terminal/blob/main/src/catppuccin-mocha.theme

# Setup external display (Viotek ultrawide in office)
# https://lecorbeausvault.wordpress.com/2021/09/25/using-xrandr-for-multi-monitor-setups-plus-some-useful-scripts/
#
# xrandr --output eDP1 --primary --mode 2560x1440 --output DP2-3 --mode 3440x1440 --right-of eDP1

echo "Reminders:"
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll\n!!\n!!\n!!"
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
