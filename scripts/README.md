# Repository utilities

## Validation

```sh
bash scripts/validate.sh
bash scripts/validate.sh --nix
```

Requires Git, Bash, POSIX sh, ShellCheck, and ripgrep (`rg`). Validates tracked
working-tree `.sh` files using their declared shell (`sh -n` or `bash -n`) and
ShellCheck. New files must be added to Git to be included. Deleted files and
symlinks are skipped. It never executes setup scripts.

The heuristic secret scan checks tracked files for private-key headers and common
AWS, GitHub, GitLab, and Slack token formats. Only filenames are printed. Review
matches manually; false positives and unrecognized secrets are possible. Git
history and untracked files are not scanned.

`--nix` additionally runs `nix flake check --no-update-lock-file ./nixos`.
This requires Nix and may download dependencies, evaluate configuration, and
build checks. It does not activate a system configuration.

Exit codes: 0 = passed, 1 = findings/check failure, 2 = usage or required-tool error.
Existing legacy script findings are reported rather than suppressed.

## Git credentials

The shared, Ubuntu, and EndeavourOS Git configs reset inherited credential
helpers and use `cache --timeout=3600`, keeping credentials in memory for one
hour rather than saving them in plaintext. For native secure storage, use
`osxkeychain` on macOS or Git Credential Manager (`manager`) on Windows.

Changing helpers does **not** remove old plaintext credential files. Review and
remove any obsolete `~/.git-credentials` or
`${XDG_CONFIG_HOME:-$HOME/.config}/git/credentials` files manually after confirming
your new authentication method works. Rotate credentials if they were exposed.
