# MacOS Dotfiles

# Install Software

```bash
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Fast Node Manager - fnm. Uses .nvmrc files.

# Homebrew

```shell
brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
```

Java - Read the post install instructions to link the java directories.
Rectangle - window management and resizing shortcuts for mac. https://github.com/rxhanson/Rectangle

```shell
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

brew install openjdk@11
brew info openjdk@11
brew reinstall openjdk@11
```


# Tmux Plugin Manager

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

