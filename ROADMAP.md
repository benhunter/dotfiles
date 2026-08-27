# Dotfiles Cleanup & Modernization Roadmap

This document outlines the target architecture, 3-layer modular structure, and phase-by-phase cleanup tasks to improve the **organization**, **simplicity**, **security**, and **maintainability** of this dotfiles repository across multiple operating systems and specific host machines.

---

## 🎯 Target Directory Structure (Layered Architecture)

The repository uses a **3-Layer Inheritance Pattern (Common $\rightarrow$ OS $\rightarrow$ Host)**:
1. **`common/`**: Universal dotfiles shared across all operating systems and machines.
2. **`os/`**: Platform-specific defaults, package bases, and bootstrap scripts (Windows, macOS, Linux).
3. **`hosts/`**: Machine-specific configurations, environment paths, hardware overrides, and supplemental package lists (e.g., `CONAN`, `LAST`, `spidey-raspi5`).

```text
dotfiles/
├── .gitignore
├── LICENSE
├── README.md
├── ROADMAP.md
│
├── common/                          # Layer 1: Universal configs (All OS & Hosts)
│   ├── .gitconfig                  # Base gitconfig (aliases, colors, delta, defaults)
│   ├── .ideavimrc                  # Shared IdeaVim keymaps
│   ├── .tmux.conf                  # Shared Tmux configuration (TPM + theme)
│   ├── nvim/                       # Unified Neovim configuration (NvChad v2.5)
│   │   ├── init.lua
│   │   └── lua/
│   ├── shell/                      # Shared shell definitions
│   │   ├── aliases.sh              # Cross-platform aliases (gs, nv, dcp, lsd, etc.)
│   │   └── p10k.zsh                # Powerlevel10k prompt theme
│   └── browser-plugins/            # Browser extension settings & uBlock filters
│       ├── ublock-filters.txt
│       └── vimium-options.json
│
├── os/                              # Layer 2: OS-level defaults & tooling
│   ├── windows/
│   │   ├── Microsoft.PowerShell_profile.ps1 # Base Windows profile (loads common + host)
│   │   ├── terminal-settings.json           # Default terminal settings (Nord + Catppuccin)
│   │   ├── packages-base.config             # Core Windows packages (Git, Neovim, Terminal, 7zip)
│   │   ├── backup-windows.ps1               # Automated backup utility
│   │   └── scripts/                         # Windows debloat / utility scripts
│   ├── macos/
│   │   ├── .zshrc                           # Base macOS zshrc (loads common + host)
│   │   ├── Brewfile.base                    # Core macOS CLI tools & casks
│   │   ├── backup-mac.sh
│   │   ├── setup-mac.sh
│   │   └── iterm/                           # iTerm2 themes & settings
│   └── linux/
│       ├── .zshrc                           # Base Linux zshrc
│       ├── backup-linux.sh
│       └── setup-linux.sh                   # Unified Linux bootstrap script
│
├── hosts/                           # Layer 3: Host-specific overrides & extra packages
│   │
│   ├── CONAN/                       # Host: CONAN (Windows workstation / WSL)
│   │   ├── packages.config          # CONAN-specific packages (Visual Studio, CUDA, gradle)
│   │   ├── host-profile.ps1         # CONAN Windows PowerShell environment
│   │   ├── zshrc.zsh                # CONAN WSL/Linux Zsh environment (Ruby paths, etc.)
│   │   └── terminal-settings.json   # CONAN-specific theme override (Catppuccin Mocha)
│   │
│   ├── LAST/                        # Host: LAST (Windows portable / dev machine)
│   │   ├── packages.config          # LAST-specific packages (fnm, tinytex, zeal)
│   │   ├── host-profile.ps1         # LAST Windows PowerShell environment
│   │   └── zshrc.zsh                # LAST WSL/Linux Zsh environment (fnm, local paths)
│   │
│   ├── dev-00/                      # Host: dev-00 (Linux development server)
│   │   ├── zshrc.zsh                # dev-00 Zsh overrides (kubectl plugin, opencode PATH)
│   │   └── packages.txt             # dev-00 supplemental packages
│   │
│   ├── spidey-raspi5/               # Host: Raspberry Pi 5
│   │   ├── setup.sh                 # Headless server provisioning
│   │   ├── zshrc.zsh                # Pi Zsh overrides
│   │   └── podman/                  # Podman container configs
│   │
│   └── nixos/                       # Host: NixOS machine
│       ├── flake.nix
│       ├── configuration.nix
│       └── home.nix
│
├── backups/                         # Historical host backups (temporary reference)
│   ├── CONAN/
│   └── LAST/
│
└── scripts/                         # Repository maintenance & installation utilities
    ├── install-symlinks.sh          # Linux/macOS symlinker (or GNU Stow wrapper)
    ├── Install-Symlinks.ps1         # Windows symlinker
    └── functions.sh
```

---

## 🧩 How Multi-Host Composition Works

### 1. PowerShell Profile Composition (Windows)
The base profile (`os/windows/Microsoft.PowerShell_profile.ps1`) establishes common utilities, then dynamically sources the host-specific file if present:

```powershell
# 1. Load universal aliases
$commonAliases = "$PSScriptRoot\..\..\common\shell\aliases.ps1"
if (Test-Path $commonAliases) { . $commonAliases }

# 2. Base functions & tab completion (Watch-Command, git-aliases, choco completion)
# ...

# 3. Dynamically source host profile
$hostProfile = "$PSScriptRoot\..\..\hosts\$env:COMPUTERNAME\host-profile.ps1"
if (Test-Path $hostProfile) {
    Write-Host "[INFO] Sourcing host profile: $hostProfile" -ForegroundColor Cyan
    . $hostProfile
}
```

### 2. Zsh Shell Composition (macOS & Linux / WSL)
The base Zsh configuration (`os/linux/.zshrc` and `os/macos/.zshrc`) loads shared aliases, base plugins, and prompt themes, then dynamically sources host-specific additions and extra plugins:

```zsh
# 1. Universal aliases & themes
[[ -f "$DOTFILES_DIR/common/shell/aliases.sh" ]] && source "$DOTFILES_DIR/common/shell/aliases.sh"
[[ -f "$DOTFILES_DIR/common/shell/p10k.zsh" ]] && source "$DOTFILES_DIR/common/shell/p10k.zsh"

# 2. Base plugins (git, zsh-autosuggestions, fzf)
plugins=(git zsh-autosuggestions fzf $ZSH_PLUGINS_EXTRA)

# 3. Host-specific Zsh overrides & additions (e.g. hosts/CONAN/zshrc.zsh, hosts/dev-00/zshrc.zsh)
HOST_ZSH="$DOTFILES_DIR/hosts/$(hostname)/zshrc.zsh"
if [[ -f "$HOST_ZSH" ]]; then
    source "$HOST_ZSH"
fi

# 4. Optional uncommitted local machine overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

**What can `hosts/<hostname>/zshrc.zsh` provide?**
* **Host-specific plugins:** e.g. `ZSH_PLUGINS_EXTRA=(kubectl helm docker)` on development servers.
* **Host-specific paths & env vars:** e.g. CUDA paths, Ruby gem directories, Opencode paths (`$HOME/.opencode/bin`), or AI infra variables (`PAI_DIR`, `DA`, `TIME_ZONE`).
* **Hardware/Network commands:** Specific display outputs (`xrandr`), proxy exports, or AWS profiles (`actx`).

### 3. Package Management Composition
* **Base Layer:** `os/windows/packages-base.config` installs core essentials (`git`, `neovim`, `microsoft-windows-terminal`, `hack-nerd-font`).
* **Host Layer:** The installation script automatically checks `hosts/$env:COMPUTERNAME/packages.config` (Windows) or `hosts/$(hostname)/packages.txt` (Linux/macOS) and installs supplemental tools (e.g. `visualstudio2022buildtools` on CONAN, `tinytex` on LAST).

### 4. Git Identity & Platform Includes
`common/.gitconfig` defines shared aliases, colors, and delta pager settings, finishing with an include directive:

```ini
[include]
    path = ~/.gitconfig.local
```

Machine-specific emails, GPG signing keys, or work identities live in `~/.gitconfig.local` without modifying tracked repository files.

---

## 📋 Cleanup & Migration Action Items

### Phase 1: Security & Privacy Hardening 🚨

- [x] **Fix Insecure Git Credential Storage**
  - Replace `helper = store` in base and OS `.gitconfig` files with OS-native credential helpers:
    - macOS: `helper = osxkeychain`
    - Windows: `helper = manager` (Git Credential Manager)
    - Linux: `helper = libsecret` (or `cache --timeout=3600`)
- [x] **Sanitize Internal Enterprise / Work Tokens in `.npmrc`**
  - Remove work-specific internal URLs (`gitlab.create.army.mil`) and auth tokens (`NPM_ASVE_READ_ONLY_TOKEN`) from `mac/.npmrc`.
  - Move enterprise registries to a private work config or machine-local `.npmrc`.
- [x] **Protect Private SSH Hosts & Keys**
  - Remove committed hostnames (`mcso-aos`, `atyourservice.benhunter.me`) and key filenames (`LightsailDefaultKey-us-east-2.pem`) from `endeavouros-i3/.ssh/config`.
  - Migrate private host entries to an uncommitted `~/.ssh/config.local` with `Include ~/.ssh/config.local` in the template.
- [x] **Guard Secrets Sourcing**
  - Add existence checks before sourcing secrets in shell configurations:
    ```zsh
    [[ -f "$HOME/.secrets.zshrc" ]] && source "$HOME/.secrets.zshrc"
    ```

---

### Phase 2: Dead Files & Redundancy Elimination 🧹

- [x] **Remove Binary Blobs in `mac/bin/`**
  - Remove `mac/bin/bfg-1.14.0.jar` and `mac/bin/bfg.jar` (~27MB total).
  - Update `mac/.zshrc` to use `brew install bfg` or download BFG on-demand.
- [x] **Remove Outdated Snapshots & Inactive Directories**
  - [x] Delete `mac/old/` (`mac/old/.config/nvim/init.vim`).
  - [x] Delete legacy Vimscript config at root: `.config/nvim/init.vim` and `neovim-install.sh`.
  - [x] Delete dated WSL install snapshot: `wsl/2022-08-07-install.sh`.
  - [x] Delete `.tmux.conf.old` (superseded by modern `.tmux.conf`).
- [x] **Clean Up Corrupted / Placeholder Files**
  - [x] Remove `mac/.ideavimrc` (10-byte placeholder; root `.ideavimrc` is canonical).
- [x] **Consolidate Package Lists & Remove Bloated Package Dumps**
  - [x] Remove `endeavouros-i3/pacman/pacman-q-all-installed-packages.txt` (keep explicit list `pacman-packages.txt`).
  - [ ] Remove duplicate `Windows/choco/` directory once reconciled with `hosts/` and `Windows/install-choco-packages.ps1`.
- [x] **Evaluate Host-Specific & Reference Files**
  - [x] Review `ubuntu/.zshrc.conan`, `ubuntu/.zshrc.dev-00`, `ubuntu/.zshrc.last` and migrate unique settings to `hosts/<hostname>/`.
  - [ ] Remove `kali-live/.zshrc.default` if stock reference is no longer needed.
  - [ ] Review `.tmux.conf.nested` (integrate F12 prefix toggle into main `.tmux.conf` or remove).

---

### Phase 3: Syntax & Shell Bug Fixes 🐛

- [x] **Fix Lua Syntax Error in Ubuntu Neovim Init**
  - Change `# TODO update to use my nvchat-config` to `-- TODO ...` in `ubuntu/.config/nvim/init.lua`.
- [x] **Fix Pager Typo in Ubuntu Zshrc comment**
  - Fix comment from moar to moor in `ubuntu/.zshrc`.
- [x] **Quote Variables in Scripts**
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
  - Replace hardcoded Kubo path (`C:\Program Files\kubo_v0.24.0\kubo`) with dynamic PATH in CONAN host profile or package manager shim.

---

### Phase 5: Modularization & Architecture Unification 🏗️

- [x] **Establish `common/`, `os/`, and `hosts/` Directories**
  - Populate `common/` with canonical `.gitconfig`, `.ideavimrc`, `.tmux.conf`, and `nvim/`.
  - Populate `hosts/CONAN/` and `hosts/LAST/` with their respective packages and profile overrides.
- [ ] **Unify Neovim Configurations**
  - Standardize on a single canonical NvChad v2.5 configuration under `common/nvim/`.
  - Configure conditional handling for VSCode Neovim vs standalone terminal Neovim in a single config.
- [x] **Modularize Git Configuration with `[include]`**
  - Place shared aliases, colors, delta pager settings, and default branch in `common/.gitconfig`.
  - Use `[include]` / `[includeIf]` for platform-specific and work-specific overrides.
- [ ] **Consolidate Distro Setup Scripts**
  - Merge overlapping setup scripts (`setup-ubuntu.sh`, `bootstrap-ubuntu.sh`, `setup-xubuntu.sh`, `setup-wsl-ubuntu.sh`) into a streamlined `os/linux/setup-linux.sh`.
- [ ] **Implement Symlink Automation**
  - Create `scripts/Install-Symlinks.ps1` (Windows) and `scripts/install-symlinks.sh` (POSIX) to manage symlinks automatically.
