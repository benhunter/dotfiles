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

## Issues

- [x] 2024-06-16 - catppuccin SDDM theme broken. Firefox is back to light mode (using system theme). PR pending: https://github.com/catppuccin/nix/issues/229

# References

- [ZaneyOs](https://gitlab.com/Zaney/zaneyos)
