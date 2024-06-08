# EndeavourOS

## Displays

Tools
- `xrandr` to manage displays from the command line.
- `arandr` for a GUI display manager.

Commands
```shell
xrandr --output eDP1 --primary --mode 2560x1440 --output DP2-3 --mode 3440x1440 --right-of eDP1 --auto
xrandr --auto
```

## JetBrains Toolbox - IntelliJ IDEA, RustRover, PyCharm

- [Download](https://www.jetbrains.com/toolbox-app/)

```shell
tar xvf jetbrains-toolbox-<VERSION>.tar.gz
mv jetbrains-toolbox-<VERSION>/jetbrains-toolbox "$HOME/.local/bin"
```
