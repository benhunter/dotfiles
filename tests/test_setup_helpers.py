"""Isolated setup-helper tests; no installers, network, or sudo are invoked.

Run: python3 -m unittest discover -s tests -v
"""

from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


def helpers_from(script, start, end):
    """Extract only function definitions, never the setup script's top level."""
    text = (ROOT / script).read_text()
    start_index = text.index(start)
    end_index = text.index(end, start_index)
    return text[start_index:end_index]


class SetupHelperTests(unittest.TestCase):
    def run_helpers(self, script, start, end, assertions):
        helpers = helpers_from(script, start, end)
        with tempfile.TemporaryDirectory() as directory:
            result = subprocess.run(
                ["bash", "-c", 'set -e\ncd "$1"\n' + helpers + assertions,
                 "helper-test", directory],
                text=True,
                capture_output=True,
            )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_links_and_backups(self):
        assertions = r'''
printf original > target
printf earlier > target.bak
printf desired > source
link_file "$PWD/source" "$PWD/target"
[[ $(cat target.bak) == earlier && $(cat target.bak.1) == original ]]
[[ -L target && $(readlink target) == "$PWD/source" ]]
link_file "$PWD/source" "$PWD/target"
[[ ! -e target.bak.2 && ! -L target.bak.2 ]]

ln -s nonexistent dangling
link_file "$PWD/source" "$PWD/dangling"
[[ -L dangling.bak && $(readlink dangling.bak) == nonexistent ]]

mkdir config
printf preserved > config/local
link_file "$PWD/source" "$PWD/config"
[[ $(cat config.bak/local) == preserved ]]

link_file "$PWD/missing-host" "$PWD/host"
[[ ! -e host && ! -L host ]]
'''
        for script, start, end in self.scripts():
            with self.subTest(script=script):
                self.run_helpers(script, start, end, assertions)

    def test_existing_repositories(self):
        assertions = r'''
git init -q repo
printf local > repo/untracked
ensure_repo unused "$PWD/repo"
ensure_repo unused "$PWD/repo"
[[ $(cat repo/untracked) == local ]]
mkdir not-a-repo
if ensure_repo unused "$PWD/not-a-repo"; then exit 1; fi
ln -s nonexistent dangling-repo
if ensure_repo unused "$PWD/dangling-repo"; then exit 1; fi
[[ -L dangling-repo ]]
'''
        for script, start, end in self.scripts():
            with self.subTest(script=script):
                self.run_helpers(script, start, end, assertions)

    def test_mac_copy_rerun(self):
        self.run_helpers(*self.scripts()[0], r'''
printf source > source
printf original > copy
copy_file "$PWD/source" "$PWD/copy"
[[ $(cat copy) == source && $(cat copy.bak) == original ]]
copy_file "$PWD/source" "$PWD/copy"
[[ ! -e copy.bak.1 && ! -L copy.bak.1 ]]
copy_file "$PWD/missing" "$PWD/skipped"
[[ ! -e skipped && ! -L skipped ]]
''')

    def test_ubuntu_package_checks(self):
        self.run_helpers(*self.scripts()[1], r'''
# Package names need not match executable names.
dpkg-query() {
    case "${@: -1}" in
        fd-find|libssl-dev) printf 'install ok installed' ;;
        *) return 1 ;;
    esac
}
sudo() { printf '%s\n' "$*" >> installs; }
install_apt fd-find libssl-dev
[[ ! -e installs ]]
install_apt fd-find missing-package
grep -q 'install -y missing-package' installs
[[ $(wc -l < installs) -eq 1 ]]
''')

    @staticmethod
    def scripts():
        return [
            ("mac/setup-mac.sh", "backup_path() {", "# Homebrew may"),
            ("ubuntu/setup-ubuntu.sh", "link_file() {", "# Preserve other sudoers"),
        ]


if __name__ == "__main__":
    unittest.main()
