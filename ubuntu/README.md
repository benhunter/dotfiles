# Ubuntu

Custom config for each host lives in `.zshrc.hostname`.

```shell
visudo
# %sudo   ALL=(ALL:ALL) NOPASSWD:ALL

sudo apt install zsh -y
chsh -s $(which zsh)

sudo apt-get install neovim -y

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# PowerLevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# mcso-aos
sudo apt install aqemu make git gcc
```

# Hack Nerd Font

https://www.nerdfonts.com/
