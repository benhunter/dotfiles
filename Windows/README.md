# Windows Config and Setup

## Package Managers

Chocolatey
- Package management on Windows is still a hot mess. Choco is nice, but there are too many packages that are out of date because they community maintained and therefore unusable.

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
