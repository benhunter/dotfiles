#!/bin/sh
#
# Install Hack NerdFont

HACK_NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
wget -P ~/.local/share/fonts $HACK_NF_URL \
  && cd ~/.local/share/fonts \
  && unzip Hack.zip \
  && rm Hack.zip \
  && fc-cache -fv
