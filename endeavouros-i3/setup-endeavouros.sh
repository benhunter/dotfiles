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
echo "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"

exit # TODO remove

# Rust
echo "Installing Rust..."
# TODO curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# TODO Rust install prompts for options.

# bottom
echo "Installing bottom..."
# TODO cargo install bottom --locked

## NvChad
## https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
# TODO git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
echo "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"

## Neovim config for VSCode Remote
echo "Copying Neovim config..."
# TODO cp .config/nvim/init.lua $HOME/.config/nvim

# fd
echo "Linking fdfind to fd..."
# mkdir -p ~/.local/bin
# TODO ln -s $(which fdfind) ~/.local/bin/fd

echo "Reminders:"
echo "!!\n!!\n!!  To finish NvChad config, run NvChadUpdate and MasonInstallAll to finish NvChad setup\n!!\n!!\n!!"
echo "!!\n!!\n!!  To finish tmux config, Open tmux, [prefix] + I\n!!\n!!\n!!"
