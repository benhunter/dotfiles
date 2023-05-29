#!/bin/sh

brew upgrade # Homebrew
omz update #oh-my-zsh


git -C ~/.tmux/plugins/tpm/bin/update_plugins pull
~/.tmux/plugins/tpm/bin/update_plugins all

# TODO
# NvChad
## Mason
