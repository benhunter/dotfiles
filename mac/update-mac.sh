#!/bin/sh

# Homebrew
brew update
brew upgrade
brew cleanup

# oh-my-zsh
omz update

# tmux
git -C ~/.tmux/plugins/tpm/bin/update_plugins pull
~/.tmux/plugins/tpm/bin/update_plugins all

# tlmgr - LaTeX packages
sudo tlmgr update --self
sudo tlmgr update --all

# TODO
# update zsh-autosuggestions?
# NvChad
## Mason
