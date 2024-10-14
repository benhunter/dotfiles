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

# Lock screen

```
hyperlock
```

# Rust Derivations

- https://nixos.wiki/wiki/Rust#Building_Rust_crates_that_require_external_system_libraries
- https://dev.to/misterio/how-to-package-a-rust-app-using-nix-3lh3
- https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md

# Troubleshooting Home Manager

```
systemctl status home-manager-ben.service
journalctl -u home-manager-ben.service
```

# Neovim

Nightly
```
nix run "github:nix-community/neovim-nightly-overlay"
```

# Issues

- [x] 2024-06-16 - catppuccin SDDM theme broken. Firefox is back to light mode (using system theme). PR pending: https://github.com/catppuccin/nix/issues/229
- [ ] trace: warning: ben profile: `gtk.catppuccin.enable` and `gtk.catppuccin.gnomeShellTheme` are deprecated and will be removed in a future release.
- [ ] The upstream port has been archived and support will no longer be provided. Please see https://github.com/catppuccin/gtk/issues/262
- [x] trace: warning: ben profile: The option `programs.zsh.enableAutosuggestions' defined in `/nix/store/hx5wfngpvw6d5aww0yv81fmd8r2gvknv-source/home.nix' has been renamed to `programs.zsh.autosuggestion.enable'.
- [ ] Firefox back to light mode after removing xserver/lightdm. Check https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/#fixing-problems-with-themes for the GTK theme config.

# References

- [ZaneyOs](https://gitlab.com/Zaney/zaneyos)

## Waybar config

- [Waybar config](https://www.youtube.com/watch?v=rW3JKs1_oVI)
- https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/dotfiles/waybar/themes/starter/config?ref_type=heads
- [Default Waybar config](https://github.com/Alexays/Waybar/blob/master/resources/config.jsonc)
- [Nix example](https://github.com/maximbaz/dotfiles/blob/nix/modules/linux/waybar.nix)
