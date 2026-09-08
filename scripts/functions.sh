# shellcheck shell=sh

# Usage: has COMMAND
# Return success if COMMAND is available on PATH.
has() {
  command -v "$1" >/dev/null 2>&1
}

# Usage: script_dir SCRIPT_PATH
# Print the physical directory containing SCRIPT_PATH.
script_dir() {
  dirname "$(realpath "$1")"
}

# Usage: backup_path TARGET
# Move TARGET to TARGET.bak, TARGET.bak.1, etc. without overwriting backups.
backup_path() {
  target=$1
  backup=$target.bak
  n=1
  if [ -e "$target" ] || [ -L "$target" ]; then
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup=$target.bak.$n
      n=$((n + 1))
    done
    mv -- "$target" "$backup"
  fi
}

# Usage: link_file SOURCE TARGET
# Symlink SOURCE to TARGET, backing up an existing TARGET first.
link_file() {
  source=$1
  target=$2
  if [ ! -e "$source" ] && [ ! -L "$source" ]; then
    echo "Skipping missing source: $source"
    return 0
  fi
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return 0
  fi
  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  ln -s "$source" "$target"
}

# Usage: copy_file SOURCE TARGET
# Copy SOURCE to TARGET, backing up an existing different TARGET first.
copy_file() {
  source=$1
  target=$2
  if [ ! -f "$source" ]; then
    echo "Skipping missing source: $source"
    return 0
  fi
  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    return 0
  fi
  mkdir -p "$(dirname "$target")"
  backup_path "$target"
  cp "$source" "$target"
}

# Usage: ensure_repo URL TARGET
# Ensure TARGET is a Git checkout, cloning URL when TARGET does not exist.
ensure_repo() {
  url=$1
  target=$2
  if [ -d "$target/.git" ] || [ -f "$target/.git" ]; then
    echo "Using existing checkout: $target"
    git -C "$target" rev-parse --is-inside-work-tree >/dev/null
  elif [ -e "$target" ] || [ -L "$target" ]; then
    echo "Refusing to overwrite non-Git path: $target" >&2
    return 1
  else
    mkdir -p "$(dirname "$target")"
    git clone --depth=1 "$url" "$target"
  fi
}

# Usage: install_apt PACKAGE...
# Install only missing apt packages on Debian-based systems.
install_apt() {
  missing=
  for pkg do
    if [ "$(dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null)" != 'install ok installed' ]; then
      missing=$missing${missing:+ }$pkg
    fi
  done
  if [ -n "$missing" ]; then
    # shellcheck disable=SC2086
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $missing
  fi
}

# Usage: git_commit [directory]
# Stage all changes in the repository and commit on the current branch.
# Existing staged changes are included. Branch selection and remote sync are
# the caller's responsibility. No SCRIPT_DIR or other caller variable is needed.
git_commit() (
  if [ "$#" -gt 1 ]; then
    echo "Usage: git_commit [directory]" >&2
    return 1
  fi
  repo=$(git -C "${1:-.}" rev-parse --show-toplevel) || return 1
  git -C "$repo" add -A || return 1

  status=0
  git -C "$repo" diff --cached --quiet || status=$?
  case "$status" in
    0) echo "No changes to commit."; return 0 ;;
    1) ;;
    *) return "$status" ;;
  esac

  git -C "$repo" commit -v || return 1
)
