# NixOs Config

## Install

Run `update-nixos.sh`

Manually:

```shell
nix flake update
sudo cp ~/projects/dotfiles/nixos/* /etc/nixos/ && sudo nixos-rebuild switch
```

# Network and Wifi Configuration

```shell
nmtui
nmcli
```

# Bluetooth

```shell
bluetoothctl

list # show bluetooth controlller
devices # show devices
discoverable on
pair XX:XX...
discoverable off
```

# Monitors

```shell
hyprctl monitors
```

# Audio & Speakers

```
alsamixer
```

# zsh Powerlevel10k

- https://www.reddit.com/r/NixOS/comments/ty9jop/comment/k4rtvs3/

## Issues

- [x] 2024-06-16 - catppuccin SDDM theme broken. Firefox is back to light mode (using system theme). PR pending: https://github.com/catppuccin/nix/issues/229
- [ ] trace: warning: ben profile: `gtk.catppuccin.enable` and `gtk.catppuccin.gnomeShellTheme` are deprecated and will be removed in a future release.
- [ ] The upstream port has been archived and support will no longer be provided. Please see https://github.com/catppuccin/gtk/issues/262
- [x] trace: warning: ben profile: The option `programs.zsh.enableAutosuggestions' defined in `/nix/store/hx5wfngpvw6d5aww0yv81fmd8r2gvknv-source/home.nix' has been renamed to `programs.zsh.autosuggestion.enable'.

# References

- [ZaneyOs](https://gitlab.com/Zaney/zaneyos)
