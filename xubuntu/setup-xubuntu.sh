#!/bin/sh
#
# Setup Xubuntu
#
# First, run bootstrap-xubuntu.sh which uses this script.
# This script is basically a copy of ubuntu/setup-ubuntu.sh.

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

echo "Installing nice things from apt ..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y tree fd-find fzf unzip tmux golang-go direnv

echo "Installing zsh..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh

# TODO check if zsh is already default shell
DEFAULT_SHELL=$(getent passwd $USER | cut -d: -f7)
IS_DEFAULT_SHELL=$(echo $DEFAULT_SHELL | grep zsh)
if [ -n "$IS_DEFAULT_SHELL" ]; then
    echo "Default shell is already zsh."
else
    echo "Changing shell to zsh..."
    echo "!! EXIT ZSH IMMEDIATELY TO CONTINUE THIS SETUP SCRIPT !!"
    chsh -s $(which zsh) # change for $USER, not root
    sudo chsh -s $(which zsh)
fi

echo "Installing LaTeX..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y texlive texlive-formats-extra

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
ln -s $SCRIPT_DIR/../ubuntu/.zshrc $HOME/.zshrc
echo "Linking .p10k.zsh..."
ln -s $SCRIPT_DIR/../ubuntu/.p10k.zsh $HOME/.p10k.zsh

# zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

echo "Linking .gitconfig..."
ln -s $SCRIPT_DIR/../ubuntu/.gitconfig $HOME/.gitconfig

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
# TODO Rust install prompts for options.

# bottom
echo "Installing bottom..."
cargo install bottom --locked

# delta - https://github.com/dandavison/delta
cargo install git-delta

# fnm and Node
curl -fsSL https://fnm.vercel.app/install | bash # TODO zsh? + Script attempts to modify .bashrc but fails.
source $HOME/.zshrc # TODO source not found?
fnm install 20 # TODO fnm not found?

$SCRIPT_DIR/install-neovim.sh

## Python prerequisites - docs may be outdated
#sudo apt-get install python2-dev python-pip python3-dev python3-pip
sudo apt install python3.12-venv

## NvChad for Neovim
## https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
git clone https://github.com/benhunter/nvchad-config ~/.config/nvim --depth 1 && nvim
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"

# fd
echo "Linking fdfind to fd..."
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd

$SCRIPT_DIR/install-hack-nerdfonts.sh

# moar - the pager that's better than less
go install github.com/walles/moar@latest

echo "Reminders:"
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
