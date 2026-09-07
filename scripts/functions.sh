# shellcheck shell=sh

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
