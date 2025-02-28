# Windows Subsystem for Linux

# .gitconfig on conan

```
[credential]
        gitLabAuthModes = pat
        helper = store
[credential "https://dev.azure.com"]
        useHttpPath = true
```

# direnv bug in Ubuntu WSL 2024-09-07

- $PATH gets mangled/replaced unexpectedly
- related? https://github.com/direnv/direnv/issues/253

# Install delta diff tool

Used for git diff pager. Provides merge.conflictsyle = zdiff3.

```
cargo install git-delta
```
