#!/bin/sh
#
# TODO setup one liner
# Run with:
# TODO curl -fsSL https://raw.githubusercontent.com/benhunter/dotfiles/main/ubuntu/setup-ubuntu.sh | bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

has() { command -v "$1" >/dev/null 2>&1; }

# update sudoers
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if [ ! -f /etc/sudoers/sudoers.d/user ];
then 
    # if $LINE is not in /etc/sudoers.d/user
    if ! sudo grep -qF "$LINE" /etc/sudoers.d/user;
    then
        echo $LINE | (sudo su -c 'EDITOR="tee" visudo -f /etc/sudoers.d/user')
    fi;
fi;

# apt packages
echo "Updating apt..."
sudo DEBIAN_FRONTEND=noninteractive apt update
echo "Upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "Full-upgrading apt..."
sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y

echo "Installing nice things from apt ..."
for pkg in tree fd-find fzf unzip tmux direnv; do
    if ! has "$pkg"; then
        sudo DEBIAN_FRONTEND=noninteractive apt install -y "$pkg"
    fi
done

echo "Installing zsh..."
if ! has zsh; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh
fi

DEFAULT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [ "$DEFAULT_SHELL" != "$(which zsh)" ]; then
    echo "Changing shell to zsh..."
    chsh -s "$(which zsh)"
fi
# TODO have to enter password for sudo. Can we chsh last?

# mcso-aos
# echo "Installing mcso-aos dependencies..."
for pkg in aqemu make git gcc valgrind inotify-tools texlive texlive-formats-extra; do
    if ! has "$pkg"; then
        sudo DEBIAN_FRONTEND=noninteractive apt install -y "$pkg"
    fi
done

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
# TODO Oh My Zsh prompts to switch default shell to zsh. Then drops into zsh. Have to exit to continue script.

# PowerLevel10k
# Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$THEME_DIR" ]; then
    echo "Installing PowerLevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
fi

# .zshrc
echo "Backing up and linking .zshrc..."
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc

echo "Backing up and linking .zshrc.$(hostname)..."
HOST_ZSHRC=".zshrc.$(hostname)"
if [ -f "$HOME/$HOST_ZSHRC" ]; then
    mv "$HOME/$HOST_ZSHRC" "$HOME/$HOST_ZSHRC.break"
fi
ln -sf "$SCRIPT_DIR/$HOST_ZSHRC" "$HOME/$HOST_ZSHRC"

echo "Linking .p10k.zsh..."
ln -sf $SCRIPT_DIR/.p10k.zsh $HOME/.p10k.zsh

# zsh-autosuggestions
ZSH_PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_PLUGIN_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGIN_DIR"
else
    git -C "$ZSH_PLUGIN_DIR" pull
fi

echo "Linking .gitconfig..."
ln -sf $SCRIPT_DIR/.gitconfig $HOME/.gitconfig

# Tmux
echo "Linking .tmux.conf..."
ln -sf "$SCRIPT_DIR/../.tmux.conf" "$HOME/.tmux.conf"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux plugins..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"

# Rust
if ! has cargo; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # TODO Rust install prompts for options.
    source "$HOME/.cargo/env"
fi

# rust-analyzer
rustup component add rust-analyzer

$SCRIPT_DIR/install-cargo-watch.sh

# rust crates
CRATES="just cargo-update topgrade"
echo "Installing rust cargo crates"
for crate in $CRATES; do
    if ! has "$crate"; then
        cargo install "$crate"
    fi
done

# bottom
# btm - https://github.com/ClementTsang/bottom
if ! has btm; then
  echo "Installing bottom..."
  cargo +stable install bottom --locked

fi

# delta - https://github.com/dandavison/delta
if ! has delta; then
  echo "Installing delta..."
  cargo install git-delta
fi

# leetup - https://crates.io/crates/leetup
if ! has leetup; then
  echo "Installing leetup..."
  cargo install leetup
  ln -s $SCRIPT_DIR/../.leetup $HOME/
fi

# just - https://github.com/casey/just
if ! has just; then
  echo "Installing just..."
  cargo install just
fi

# nextest
if has cargo; then
  echo "Installing cargo-nextest..."
  cargo install cargo-nextest
fi

# fnm and Node
if ! has fnm; then
  curl -fsSL https://fnm.vercel.app/install | bash # TODO zsh? + Script attempts to modify .bashrc but fails.
  # source $HOME/.zshrc # TODO source not found?
  export PATH="$HOME/.fnm:$PATH"
fi

if ! fnm list | grep -q 'v20'; then
    fnm install 20
    #fnm install 20 --corepack-enabled # for yarn
fi
eval "$(fnm env)"

# Neovim
# https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
# Use unstable repo for PPA
echo "Installing Neovim..."
if ! has nvim; then
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
  sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:neovim-ppa/unstable # TODO prompts for Enter to continue.
  sudo DEBIAN_FRONTEND=noninteractive apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y neovim python3-pip fonts-powerline ripgrep fd-find
fi

## Python prerequisites - docs may be outdated
#sudo apt-get install python2-dev python-pip python3-dev python3-pip
# sudo apt install python3.10-venv
sudo apt install python3.13-venv # 2025-07-10

## NvChad for Neovim
## https://nvchad.com/docs/quickstart/install
echo "Installing NvChad for Neovim..."
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/benhunter/nvchad-config "$HOME/.config/nvim" --depth 1 && nvim
    echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"
fi

## Neovim config for VSCode Remote
# TODO should just be in the nvim config repo
# echo "Copying Neovim config..."
# cp "$SCRIPT_DIR/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# fd
echo "Linking fdfind to fd..."
mkdir -p "$HOME/.local/bin"
ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"

# golang
# TODO https://go.dev/doc/install
if ! has go || ! go version | grep -q "go1.23.1"; then
    echo "Installing golang..."
    curl -LO https://dl.google.com/go/go1.23.1.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz
fi

# moor - the pager that's better than less
if ! has moor; then
    go install github.com/walles/moor/v2/cmd/moor@latest
    # go install github.com/walles/moar@latest # old package
fi

# pnpm - https://pnpm.io/ - used in Loco development
if ! has pnpm; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# atuin
if ! has atuin; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

echo "Reminders:"
echo -e "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"
echo -e "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
