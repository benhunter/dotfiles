#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# update sudoers
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if [ ! -f /etc/sudoers/sudoers.d/user ];
then echo $LINE | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/user')
fi;

# apt
sudo apt update
sudo apt upgrade -y

sudo apt install zsh -y
chsh -s $(which zsh)

sudo apt install neovim -y

# mcso-aos
sudo apt install aqemu make git gcc valgrind inotify-tools tree

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# oh-my-zsh

# PowerLevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc

# .zshrc
mv $HOME/.zshrc $HOME/.zshrc.bak
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -s $SCRIPT_DIR/.p10k.zsh $HOME/.p10k.zsh

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

ln -s $SCRIPT_DIR/.gitconfig $HOME/.gitconfig

# Tmux
ln -s $SCRIPT_DIR/../.tmux.conf $HOME/.tmux.conf
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
$HOME/.tmux/plugins/tpm/bin/update_plugins all

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# bottom
cargo install bottom --locked
