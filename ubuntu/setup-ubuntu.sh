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

# fnm and Node
sudo apt install unzip
curl -fsSL https://fnm.vercel.app/install | bash
source $HOME/.zshrc
fnm install 20

# Neovim
# https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
# Use unstable repo for PPA
sudo apt-get install software-properties-common
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim python3-pip fonts-powerline ripgrep fd-find

## Python prerequisites - docs may be outdated
#sudo apt-get install python2-dev python-pip python3-dev python3-pip

# NvChad
# https://nvchad.com/docs/quickstart/install
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
echo "Run NvChadUpdate and MasonInstallAll"
