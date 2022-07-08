# Install Neovim from nightly
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim python3-pip fonts-powerline ripgrep fd-find

# pynvim
pip install pynvim --upgrade

# fnm - Fast Node Manager and Node 18
curl -fsSL https://fnm.vercel.app/install | bash
fnm install 18

# Node packages
npm install -g neovim tree-sitter-cli
