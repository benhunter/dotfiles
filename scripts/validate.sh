#!/usr/bin/env bash
# Validate tracked working-tree files without executing setup scripts.
set -o pipefail

WITH_NIX=0
case "${1:-}" in
  --nix) WITH_NIX=1 ;;
  '') ;;
  -h|--help) echo "Usage: bash scripts/validate.sh [--nix]"; exit 0 ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
if (($# > 1)); then
  echo "Usage: bash scripts/validate.sh [--nix]" >&2
  exit 2
fi

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)" || exit 1
cd "$ROOT" || exit 1
for tool in git sh bash shellcheck rg; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    exit 2
  fi
done

STATUS=0
FILES=()
# Include staged additions and local edits; skip working-tree deletions/symlinks.
LIST=$(mktemp) || exit 1
trap 'rm -f "$LIST"' EXIT
git ls-files -z > "$LIST" || exit 1
while IFS= read -r -d '' file; do
  [[ -f "$file" && ! -L "$file" ]] || continue
  FILES+=("$file")
  [[ "$file" == *.sh ]] || continue
  IFS= read -r first_line < "$file"
  case "$first_line" in
    *bash*) shell='bash' ;;
    '#!/bin/sh'|'#!/usr/bin/env sh'|'# shellcheck shell=sh') shell='sh' ;;
    *) echo "No supported shell declaration: $file" >&2; STATUS=1; continue ;;
  esac
  echo "Checking $file ($shell)"
  "$shell" -n "$file" || STATUS=1
  shellcheck --shell="$shell" "$file" || STATUS=1
done < "$LIST"

# Heuristic scan: report filenames only, never print potential secret values.
# This is not a replacement for a dedicated scanner or Git-history audit.
echo "Scanning tracked files for common secret formats..."
PATTERN='-----BEGIN (RSA |EC |DSA |OPENSSH |ENCRYPTED )?PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{50,}|glpat-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{20,}'
if ((${#FILES[@]})); then
  rg --no-config --files-with-matches --text -- "$PATTERN" "${FILES[@]}"
  scan_status=$?
  case "$scan_status" in
    0) echo "Potential secrets found; review the files above." >&2; STATUS=1 ;;
    1) ;;
    *) echo "Secret scan failed." >&2; STATUS=1 ;;
  esac
fi

if ((WITH_NIX)); then
  if command -v nix >/dev/null 2>&1; then
    nix flake check --no-update-lock-file ./nixos || STATUS=1
  else
    echo "Missing required tool for --nix: nix" >&2
    STATUS=1
  fi
fi

if ((STATUS == 0)); then
  echo "Validation passed."
else
  echo "Validation failed; see diagnostics above." >&2
fi
exit "$STATUS"
