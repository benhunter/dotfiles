# MacOS Dotfiles

- Install `setup-mac.sh`
- Update `update-mac.sh`
- Backup `backup-mac.sh`

## Install and Setup

### oh-my-zsh

```shell
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Homebrew

```shell
brew tap homebrew/cask-fonts && brew install --cask font-meslo-lg-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font
```

### Fast Node Manager

fnm. Set .nvmrc file in Node project directories.

### Tmux Plugin Manager

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Neovim

Install NvChad.
Copy custom config.

`cp -R ~/projects/dotfiles/mac/.config/nvim/lua/custom /.config/nvim/lua`

[Example config](https://github.com/NvChad/example_config/tree/v2.0_featureful)

Setup Copilot with `:Copilot auth`.

### Helm

[Helm autocompletions for zsh](https://helm.sh/docs/helm/helm_completion_zsh/)
 
### Misc

Rectangle - window management and resizing shortcuts for mac. https://github.com/rxhanson/Rectangle

Java - Read the post install instructions to link the java directories.

```shell
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

brew install openjdk@11
brew info openjdk@11
brew reinstall openjdk@11
```

[Pandoc](https://pandoc.org/installing.html#macos)

## Update

### oh-my-zsh

```shell
omz update
```

## Backup 

Homebrew

```shell
brew bundle dump -f 
```

# Misc

## Ruby (hope I don't need this ever again)

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

## BasicTeX

Currently using MacTex instead of BasicTeX

Pandoc and BasicTeX fonts, algorithms.
```shell
sudo tlmgr install collection-fontsrecommended
sudo tlmgr install algorithms
```
