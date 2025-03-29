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

# Docker permissions

- https://docs.docker.com/desktop/features/wsl/#enabling-docker-support-in-wsl-2-distributions
- https://chatgpt.com/g/g-p-67e8139e4b4c8191bb6346da5bbd9747-cve-notify/c/67e83ac1-569c-800a-881f-c5051264c3eb
