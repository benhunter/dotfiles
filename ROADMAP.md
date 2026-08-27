# Dotfiles Cleanup & Modernization Roadmap

This document outlines the target architecture, modular structure, and phase-by-phase cleanup tasks to improve the **organization**, **simplicity**, **security**, and **maintainability** of this dotfiles repository.

---

## 🎯 Target Directory Structure

The goal is to transition from fragmented, distro-specific directories into a clean, modular structure where shared configurations are centralized in `common/` and OS-specific setup scripts live in `os/`:

```text
dotfiles/
├── .gitignore
├── LICENSE
├── README.md
├── ROADMAP.md
│
├── common/                          # Cross-platform, shared configurations
│   ├── .gitconfig                  # Base gitconfig (aliases, colors, delta, defaults)
│   ├── .ideavimrc                  # Canonical IdeaVim config
│   ├── .tmux.conf                  # Canonical tmux configuration (TPM + theme)
│   ├── nvim/                       # Unified modern Neovim setup (NvChad v2.5)
│   │   ├── init.lua
│   │   └── lua/
│   ├── shell/                      # Shared shell configurations
│   │   ├── aliases.sh              # Cross-platform aliases (gs, dcp, nv, lsd, etc.)
│   │   └── p10k.zsh                # Powerlevel10k theme configuration
│   └── browser-plugins/            # Browser extension settings & uBlock filters
│       ├── ublock-filters.txt
│       └── vimium-options.json
│
├── os/                              # Platform-specific configurations & bootstraps
│   ├── macos/                      # macOS (Darwin) configs & scripts
│   │   ├── .zshrc
│   │   ├── Brewfile
│   │   ├── backup-mac.sh
│   │   ├── setup-mac.sh
│   │   └── iterm/
│   ├── linux/                      # Generic Linux & Ubuntu/Debian configs
│   │   ├── .zshrc
│   │   ├── backup-ubuntu.sh
│   │   ├── setup-ubuntu.sh
│   │   └── packages/
│   ├── windows/                    # Windows 10/11 configs & scripts
│   │   ├── Microsoft.PowerShell_profile.ps1
│   │   ├── terminal-settings.json  # Windows Terminal (Nord + Catppuccin)
│   │   ├── backup-windows.ps1
│   │   └── install-packages.ps1    # Scoop / Winget / Choco installs
│   └── nixos/                      # Declarative NixOS configuration
│       ├── flake.nix
│       ├── home.nix
│       └── configuration.nix
│
├── backups/                         # Historical host backups (temporary reference)
│   ├── CONAN/
│   └── LAST/
│
└── scripts/                         # Repository maintenance & installation utilities
    ├── install-symlinks.sh         # Symlinking script (or GNU Stow / chezmoi wrapper)
    └── functions.sh
```

---

## 📋 Cleanup & Migration Action Items

### Phase 1: Security & Privacy Hardening 🚨

- [ ] **Fix Insecure Git Credential Storage**
  - Replace `helper = store` in base and OS `.gitconfig` files with OS-native credential helpers:
    - macOS: `helper = osxkeychain`
    - Windows: `helper = manager` (Git Credential Manager)
    - Linux: `helper = libsecret` (or `cache --timeout=3600`)
- [ ] **Sanitize Internal Enterprise / Work Tokens in `.npmrc`**
  - Remove work-specific internal URLs (`gitlab.create.army.mil`) and auth tokens (`NPM_ASVE_READ_ONLY_TOKEN`) from `mac/.npmrc`.
  - Move enterprise registries to a private work config or machine-local `.npmrc`.
- [ ] **Protect Private SSH Hosts & Keys**
  - Remove committed hostnames (`mcso-aos`, `atyourservice.benhunter.me`) and key filenames (`LightsailDefaultKey-us-east-2.pem`) from `endeavouros-i3/.ssh/config`.
  - Migrate private host entries to an uncommitted `~/.ssh/config.local` with `Include ~/.ssh/config.local` in the template.
- [ ] **Guard Secrets Sourcing**
  - Add existence checks before sourcing secrets in shell configurations:
    ```zsh
    [[ -f "$HOME/.secrets.zshrc" ]] && source "$HOME/.secrets.zshrc"
    ```

---

### Phase 2: Dead Files & Redundancy Elimination 🧹

- [ ] **Remove Binary Blobs in `mac/bin/`**
  - Remove `mac/bin/bfg-1.14.0.jar` and `mac/bin/bfg.jar` (~27MB total).
  - Update `mac/.zshrc` to use `brew install bfg` or download BFG on-demand.
- [ ] **Remove Outdated Snapshots & Inactive Directories**
  - [ ] Delete `mac/old/` (`mac/old/.config/nvim/init.vim`).
  - [ ] Delete legacy Vimscript config at root: `.config/nvim/init.vim` and `neovim-install.sh`.
  - [ ] Delete dated WSL install snapshot: `wsl/2022-08-07-install.sh`.
  - [ ] Delete `.tmux.conf.old` (superseded by modern `.tmux.conf`).
- [ ] **Clean Up Corrupted / Placeholder Files**
  - [ ] Remove `mac/.ideavimrc` (10-byte placeholder; root `.ideavimrc` is canonical).
- [ ] **Consolidate Package Lists & Remove Bloated Package Dumps**
  - [ ] Remove `endeavouros-i3/pacman/pacman-q-all-installed-packages.txt` (keep explicit list `pacman-packages.txt`).
  - [ ] Remove duplicate `Windows/choco/` directory once reconciled with `backups/` and `Windows/install-choco-packages.ps1`.
- [ ] **Evaluate Host-Specific & Reference Files**
  - [ ] Review `ubuntu/.zshrc.conan`, `ubuntu/.zshrc.dev-00`, `ubuntu/.zshrc.last` and retire or fold into standard paths.
  - [ ] Remove `kali-live/.zshrc.default` if stock reference is no longer needed.
  - [ ] Review `.tmux.conf.nested` (integrate F12 prefix toggle into main `.tmux.conf` or remove).

---

### Phase 3: Syntax & Shell Bug Fixes 🐛

- [ ] **Fix Lua Syntax Error in Ubuntu Neovim Init**
  - Change `# TODO update to use my nvchat-config` to `-- TODO ...` in `ubuntu/.config/nvim/init.lua`.
- [ ] **Fix Pager Typo in Ubuntu Zshrc**
  - Change `export PAGER=$(which moor)` to `export PAGER=$(which moar)` in `ubuntu/.zshrc`.
- [ ] **Quote Variables in Scripts**
  - Quote `"$SCRIPT_DIR"` in `scripts/functions.sh` to handle paths with spaces safely.

---

### Phase 4: Performance & Path Standardization ⚡

- [ ] **Eliminate Shell Startup Lag in `mac/.zshrc`**
  - Replace synchronous subshell `$(brew --prefix)` for Google Cloud SDK with static path check or precomputed `HOMEBREW_PREFIX`.
  - Replace `. $(pack completion --shell zsh)` with pre-generated completions in `fpath`.
  - Reduce `HISTSIZE=1000000000` to a reasonable in-memory size (e.g. `50000`).
- [ ] **Remove Hardcoded Usernames & Machine Paths**
  - Replace `/Users/b2186555/...` in `mac/.zshrc` with `$HOME` variables.
  - Replace `/home/ben/...` in `ubuntu/.zshrc` with `$HOME` / `~`.
  - Replace hardcoded Kubo path (`C:\Program Files\kubo_v0.24.0\kubo`) in Windows PowerShell profile with dynamic PATH or package manager shim.

---

### Phase 5: Modularization & Architecture Unification 🏗️

- [ ] **Unify Neovim Configurations**
  - Standardize on a single canonical NvChad v2.5 configuration under `common/nvim/`.
  - Configure conditional handling for VSCode Neovim vs standalone terminal Neovim in a single config.
- [ ] **Modularize Git Configuration with `[include]`**
  - Place shared aliases, colors, delta pager settings, and default branch in `common/.gitconfig`.
  - Use `[include]` / `[includeIf]` for platform-specific and work-specific overrides:
    ```ini
    [include]
        path = ~/.gitconfig.local
    [includeIf "gitdir:~/work/"]
        path = ~/.gitconfig-work
    ```
- [ ] **Consolidate Distro Setup Scripts**
  - Merge overlapping setup scripts (`setup-ubuntu.sh`, `bootstrap-ubuntu.sh`, `setup-xubuntu.sh`, `setup-wsl-ubuntu.sh`) into a streamlined `os/linux/setup.sh`.
- [ ] **Adopt Modern Dotfile Symlink Management**
  - Implement a central symlinking workflow (e.g. GNU Stow, chezmoi, or a lightweight `scripts/install-symlinks.sh`) to eliminate manual copying.
