#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Homebrew
# https://brew.sh/
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Post-install:
# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/b2186555/.zprofile eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install --file=$SCRIPT_DIR/Brewfile

# .zshrc
mv $HOME/.zshrc $HOME/.zshrc.bak
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -s $HOME/projects/secrets/.secrets.zshrc $HOME/.secrets.zshrc

ln -s $SCRIPT_DIR/env $HOME/env

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp $SCRIPT_DIR/.p10k.zsh ~/


# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

# Binaries and Scripts
mkdir -p $HOME/bin
ln -s $SCRIPT_DIR/bin/* $HOME/bin
ln -s $HOME/projects/scripts/*.sh $HOME/bin
# ln -s $SCRIPT_DIR/update-mac.sh $HOME/bin/update-mac.sh
ln -s $SCRIPT_DIR/*.sh $HOME/bin/
ln -s $HOME/scripts/*.sh $HOME/bin

# Tmux
echo "Configuring tmux..."
ln -s $SCRIPT_DIR/../.tmux.conf $HOME/.tmux.conf
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
$HOME/.tmux/plugins/tpm/bin/update_plugins all

# Git
echo "Configuring git..."
cp $SCRIPT_DIR/.gitignore_global ~/.gitignore_global
cp $SCRIPT_DIR/.gitconfig ~/
git config --global core.excludesfile ~/.gitignore_global

# Pandoc Templates
cp -r $SCRIPT_DIR/.pandoc $HOME/.pandoc

# Rust Programming Language
if ! command -v rustup &> /dev/null
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# NvChad
# https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
git clone https://github.com/benhunter/nvchad-config ~/.config/nvim && nvim
echo -e "!!\n!!\n!!  To finish NvChad config, run MasonInstallAll\n!!\n!!\n!!"

# SDKMAN https://sdkman.io/
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
cp $SCRIPT_DIR/.sdkman/etc/config $HOME/.sdkman/etc/config

# Misc
ln -s $SCRIPT_DIR/.ideavimrc $HOME/.ideavimrc
# xcode-select --install # Needed for TAP Iterate Cluster access
# tanzu plugin install --group vmware-tap/default:v1.6.1 # Needed for TAP Iterate Cluster access

# Update - Do Last
echo "Running update-mac.sh..."
$SCRIPT_DIR/update-mac.sh
