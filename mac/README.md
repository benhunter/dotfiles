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

Rectangle - window management and resizing shortcuts for mac. https://github.com/rxhanson/Rectangle

Java - Read the post install instructions to link the java directories.

```shell
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

brew install openjdk@11
brew info openjdk@11
brew reinstall openjdk@11
```


# Tmux Plugin Manager

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Ruby (hope I don't need this ever again)

Add to `.zshrc`

```shell
# Ruby - using chruby and ruby-install
# 2022-12-22
# Installed with: 
# 	brew install chruby ruby-install xz
#source /usr/local/opt/chruby/share/chruby/chruby.sh
#source /usr/local/opt/chruby/share/chruby/auto.sh
#chruby ruby-3.1.2

# Ruby - installed with brew install ruby
# Put Ruby first in PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"
# Gems installed here:
export PATH="/usr/local/lib/ruby/gems/3.1.0/bin:$PATH"
```
