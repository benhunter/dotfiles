#!/usr/bin/env bash
# Run from a local checkout: bash ubuntu/setup-ubuntu.sh

set -e
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=../scripts/functions.sh disable=SC1091
. "$SCRIPT_DIR/../scripts/functions.sh" || exit 1

# Preserve other sudoers entries and validate before replacing the file.
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if ! sudo grep -qxF "$LINE" /etc/sudoers.d/user; then
    SUDOERS_TMP=$(mktemp)
    trap 'rm -f "$SUDOERS_TMP"' EXIT
    if sudo test -e /etc/sudoers.d/user; then
        # Only the read requires root; the temporary file belongs to this user.
        # shellcheck disable=SC2024
        sudo cat /etc/sudoers.d/user > "$SUDOERS_TMP"
    fi
    printf '\n%s\n' "$LINE" >> "$SUDOERS_TMP"
    sudo visudo -cf "$SUDOERS_TMP"
    sudo install -o root -g root -m 0440 "$SUDOERS_TMP" /etc/sudoers.d/user
    rm -f "$SUDOERS_TMP"
    trap - EXIT
fi

# System updates intentionally run every time.
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
install_apt curl ca-certificates git tree fd-find fzf unzip tmux direnv kubectx zsh
install_apt aqemu make gcc valgrind inotify-tools texlive texlive-formats-extra
install_apt pkg-config libssl-dev python3-venv

DEFAULT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$DEFAULT_SHELL" != "$(command -v zsh)" ]]; then
    echo "Changing shell to zsh..."
    chsh -s "$(command -v zsh)"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ensure_repo https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
ensure_repo https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"

link_file "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
HOST_ZSHRC=".zshrc.$(hostname)"
link_file "$SCRIPT_DIR/$HOST_ZSHRC" "$HOME/$HOST_ZSHRC"
link_file "$HOME/projects/secrets/.secrets.zshrc" "$HOME/.secrets.zshrc"
link_file "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$SCRIPT_DIR/../.tmux.conf" "$HOME/.tmux.conf"
ensure_repo https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all

# Expose previously installed tools before deciding whether to install them.
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/fnm:$HOME/.fnm:$HOME/.local/share/pnpm:$HOME/.atuin/bin:/usr/local/go/bin:${GOPATH:-$HOME/go}/bin:$PATH"
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if ! has brew; then
    "$SCRIPT_DIR/../linux/install-homebrew.sh"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if ! brew list --formula hub >/dev/null 2>&1; then
    brew install hub
fi

if ! has rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
rustup component add rust-analyzer

if ! cargo watch --version >/dev/null 2>&1; then
    cargo install cargo-watch --locked
fi
if ! cargo install-update --version >/dev/null 2>&1; then
    cargo install cargo-update
fi
for crate in just topgrade; do
    if ! has "$crate"; then
        cargo install "$crate"
    fi
done
if ! has btm; then
    cargo +stable install bottom --locked
fi
if ! has delta; then
    cargo install git-delta
fi
if ! has leetup; then
    cargo install leetup
fi
link_file "$SCRIPT_DIR/../.leetup" "$HOME/.leetup"
if ! cargo nextest --version >/dev/null 2>&1; then
    cargo install cargo-nextest
fi

if ! has fnm; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi
eval "$(fnm env --shell bash)"
if ! fnm list | grep -E 'v20\.' >/dev/null; then
    fnm install 20
fi

if ! has nvim; then
    install_apt software-properties-common
    sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:neovim-ppa/unstable
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    install_apt neovim
fi
install_apt python3-pip fonts-powerline ripgrep fd-find
if [[ ! -e "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
    ensure_repo https://github.com/benhunter/nvchad-config "$HOME/.config/nvim"
fi
link_file "$(command -v fdfind)" "$HOME/.local/bin/fd"

# Keep an existing Go installation rather than downgrading it on every rerun.
GO_VERSION="go1.23.1"
if ! has go; then
    case "$(uname -m)" in
        x86_64) GO_ARCH=amd64 ;;
        aarch64|arm64) GO_ARCH=arm64 ;;
        *) echo "Unsupported Go architecture" >&2; exit 1 ;;
    esac
    GO_TMP=$(mktemp -d)
    trap 'rm -rf "$GO_TMP"' EXIT
    curl -fL "https://go.dev/dl/$GO_VERSION.linux-$GO_ARCH.tar.gz" -o "$GO_TMP/go.tar.gz"
    tar -xzf "$GO_TMP/go.tar.gz" -C "$GO_TMP"
    if [[ -e /usr/local/go || -L /usr/local/go ]]; then
        echo "Refusing to overwrite existing /usr/local/go" >&2
        exit 1
    fi
    sudo mv "$GO_TMP/go" /usr/local/go
    rm -rf "$GO_TMP"
    trap - EXIT
fi
if ! has moor; then
    go install github.com/walles/moor/v2/cmd/moor@latest
fi
if ! has pnpm; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi
if ! has atuin; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

printf '%s\n' 'Reminders:' \
    'Open nvim and run MasonInstallAll to finish NvChad setup.' \
    'Open tmux and press [prefix] + I to install plugins.'
