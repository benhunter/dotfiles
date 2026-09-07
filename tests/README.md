# Setup helper tests

Run from the repository root:

```sh
python3 -B -m unittest discover -s tests -v
```

Requires Python 3, Bash, Git, and standard Unix utilities. No third-party Python packages are needed.

The tests extract only helper definitions from `mac/setup-mac.sh` and
`ubuntu/setup-ubuntu.sh`; they do not execute the setup scripts. File operations
and local Git initialization use temporary directories. Package queries and
`sudo` are mocked; no network access or installations are performed.

Coverage:
- Repeated symlinking without additional backups.
- Preservation of existing backups, directories, and dangling symlinks.
- Missing-source handling.
- Reuse of existing repositories without changing local files.
- Refusal to overwrite non-Git paths.
- Repeated macOS config copying.
- Ubuntu package checks based on package status, not executable names.

These are helper tests, not full installer or platform integration tests.
If helper sections move, update the extraction markers in `test_setup_helpers.py`.
