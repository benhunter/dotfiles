#!/bin/sh
#
# TODO setup one liner
# Run with:
# TODO curl -fsSL https://raw.githubusercontent.com/benhunter/dotfiles/main/ubuntu/setup-ubuntu.sh | bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# update sudoers
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if [ ! -f /etc/sudoers/sudoers.d/user ];
then echo $LINE | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/user')
fi;

# apt
echo "Updating apt..."
sudo DEBIAN_FRONTEND=noninteractive apt update
echo "Upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "Installing zsh..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh
echo "Changing shell to zsh..."
chsh -s $(which zsh)
# TODO have to enter password for sudo. Can we chsh last?

# mcso-aos
echo "Installing mcso-aos dependencies..."
sudo apt install -y aqemu make git gcc valgrind inotify-tools tree fd-find

# Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# TODO Oh My Zsh prompts to switch default shell to zsh. Then drops into zsh. Have to exit to continue script.

# PowerLevel10k
echo "Installing PowerLevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc

# .zshrc
echo "Backing up and linking .zshrc..."
mv $HOME/.zshrc $HOME/.zshrc.bak
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
echo "Linking .p10k.zsh..."
ln -s $SCRIPT_DIR/.p10k.zsh $HOME/.p10k.zsh

# zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

echo "Linking .zshrc..."
ln -s $SCRIPT_DIR/.gitconfig $HOME/.gitconfig

# Tmux
echo "Linking .tmux.conf..."
ln -s $SCRIPT_DIR/../.tmux.conf $HOME/.tmux.conf
echo "Installing Tmux plugins..."
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
$HOME/.tmux/plugins/tpm/bin/update_plugins all
echo "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"

# Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# TODO Rust install prompts for options.

# bottom
echo "Installing bottom..."
cargo install bottom --locked

# fnm and Node
sudo DEBIAN_FRONTEND=noninteractive apt install -y unzip
curl -fsSL https://fnm.vercel.app/install | bash # TODO zsh? + Script attempts to modify .bashrc but fails.
source $HOME/.zshrc # TODO source not found?
fnm install 20 # TODO fnm not found?

# Neovim
# https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
# Use unstable repo for PPA
echo "Installing Neovim..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python-software-properties
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:neovim-ppa/unstable # TODO prompts for Enter to continue.
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y neovim python3-pip fonts-powerline ripgrep fd-find

## Python prerequisites - docs may be outdated
#sudo apt-get install python2-dev python-pip python3-dev python3-pip

## NvChad
## https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
echo "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"

## Neovim config for VSCode Remote
echo "Copying Neovim config..."
cp .config/nvim/init.lua $HOME/.config/nvim

# fd
echo "Linking fdfind to fd..."
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd

echo "Reminders:"
echo "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"
echo "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
