# Windows Config and Setup

## Package Managers

Chocolatey
- Package management on Windows is still a hot mess. Choco is nice, but there are too many packages that are out of date because they community maintained and therefore unusable.
- Backup Chocolatey: `choco export <package.config>`

Scoop
- https://scoop.sh/

Install Scoop:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
irm get.scoop.sh | iex
```

`install-scoop-packages.ps1` - Installs all the packages.

## Neovim config

Copy init.vim to:

C:\Users\username\AppData\Local\nvim\init.vim

Yank to system clipboard works!

## VSCode

- use Neovim with config above

`keybindings.json`

```json
// Place your key bindings in this file to override the defaultsauto[]
[
    {
        "key": "ctrl+`",
        "command": "-workbench.action.selectTheme"
    },
    {
        "command": "-vscode-neovim.send",
        "key": "ctrl+a"
    },
    {
        "command": "-vscode-neovim.send",
        "key": "ctrl+c"
    },
    {
        "command": "-vscode-neovim.send",
        "key": "ctrl+v"
    }
]

```

## IdeaVim Plugin for IntelliJ, PyCharm, etc

Copy `.ideavimrc` to user folder: `C:\Users\ben\`

## Remove the cruft

```shell
# bye cortana - Windows 10
Get-AppxPackage -allusers Microsoft. 549981C3F5F10 | Remove-AppxPackage
```

Run as admin:

```powershell
windows11-remove-widgets.ps1
```

# Powershell $PROFILE

```powershell
$PROFILE
# C:\Users\benja\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

Backup Profile
```powershell
cp $PROFILE .
```

Restore Profile
```powershell
cp Microsoft.PowerShell_profile.ps1 $PROFILE
```