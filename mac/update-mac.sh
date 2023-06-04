#!/bin/sh

brew upgrade # Homebrew
omz update #oh-my-zsh

# tmux
git -C ~/.tmux/plugins/tpm/bin/update_plugins pull
~/.tmux/plugins/tpm/bin/update_plugins all

# TODO
# update zsh-autosuggestions?
# NvChad
## Mason
