#git clone https://github.com/benhunter/dotfiles ~/projects/

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s ~/projects/dotfiles/.tmux.conf ~/.tmux.conf

# ClamAV package failure
# if clamav user no longer exists:
# sudo adduser --system --no-create-home --disabled-password --disabled-login --shell /bin/false --group --home /var/lib/clamav clamav

# rpyc Python package for gdb
# check gdb's python path and rpyc avalailability:
# gdb -batch -ex 'python print(sys.path)'
# gdb -batch -ex 'python import rpyc'
# sudo pip install rpyc --target /usr/share/gdb/python

# fnm and Node
curl -fsSL https://fnm.vercel.app/install | bash # TODO zsh? + Script attempts to modify .bashrc but fails.
source $HOME/.zshrc # TODO source not found?
fnm install 20 # TODO fnm not found?

# Neovim
# https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
echo "Installing Neovim..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip fonts-powerline ripgrep fd-find
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
export PATH="$PATH:/opt/nvim-linux64/bin"
cp ~/.zshrc ~/.zshrc.bak
echo '\n# Neovim\nPATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.zshrc


# NvChad for Neovim
# https://nvchad.com/docs/quickstart/install
echo "Installing NvChad..."
git clone https://github.com/benhunter/nvchad-config ~/.config/nvim && nvim
echo -e "!!\n!!\n!!  To finish NvChad config, run MasonInstallAll\n!!\n!!\n!!"

# Hack NerdFont
HACK_NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
wget -P ~/.local/share/fonts $HACK_NF_URL \
  && cd ~/.local/share/fonts \
  && unzip Hack.zip \
  && rm Hack.zip \
  && fc-cache -fv
