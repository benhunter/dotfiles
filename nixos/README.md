# NixOs Config

## TODO

- [ ] delta pager in gitconfig.

## Install

Requires `git`.

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

Connect to wifi and prompt for password:
```shell
nmcli device wifi connect 'SSID Name' --ask
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
- [ ] home-manager-ben can't restart when the atuin config would be clobbered. Bandaid is `watch rm -rf /home/ben/.config/atuin` during home-manager update.

# Waybar config

- [Waybar config](https://www.youtube.com/watch?v=rW3JKs1_oVI)
- https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/dotfiles/waybar/themes/starter/config?ref_type=heads
- [Default Waybar config](https://github.com/Alexays/Waybar/blob/master/resources/config.jsonc)
- [Nix example](https://github.com/maximbaz/dotfiles/blob/nix/modules/linux/waybar.nix)

# Cleanup and free space

```
nix-collect-garbage # removes unused GC-roots
nix-collect-garbage -d # removes previous revisions
```

# SSH

SSH from Kitty terminal gives "terminal unknown" error. [Kitty FAQ](https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer).

`kitten ssh user@server`

# 2025-01-05 Catppuccin broke

Error: `error: attribute 'importApply' missing`

Upgrading to unstable nixpks as in the Catppuccin nix docs.

```
       error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts.
       For example change:
         fonts.packages = [
           ...
           (pkgs.nerdfonts.override { fonts = [ "0xproto" "DroidSansMono" ]; })
         ]
       to
         fonts.packages = [
           ...
           pkgs.nerd-fonts._0xproto
           pkgs.nerd-fonts.droid-sans-mono
         ]
       or for all fonts
         fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
```

# Tailscale

- https://nixos.wiki/wiki/Tailscale
- run `sudo tailscale up --auth-key=KEY"` with the key generated at https://login.tailscale.com/admin/machines/new-linux

# References

- [ZaneyOs](https://gitlab.com/Zaney/zaneyos)

