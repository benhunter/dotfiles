"""Test git_commit with local repositories; no network or interactive editor."""

from pathlib import Path
import os
import subprocess
import tempfile
import unittest


HELPER = Path(__file__).resolve().parents[1] / "scripts/functions.sh"


class GitCommitTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="commit tests ")
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.env = dict(os.environ, GIT_EDITOR="true", GIT_CONFIG_NOSYSTEM="1",
                        GIT_CONFIG_GLOBAL=os.devnull)
        self.env.pop("SCRIPT_DIR", None)
        self.git("init", "-q", "-b", "feature")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        # Supply a message without invoking an editor.
        hook = self.repo / ".git/hooks/prepare-commit-msg"
        hook.write_text('#!/bin/sh\nprintf "Test commit\\n" > "$1"\n')
        hook.chmod(0o755)

    def git(self, *args):
        return subprocess.run(["git", "-C", str(self.repo), *args], env=self.env,
                              check=True, text=True, capture_output=True).stdout.strip()

    def commit(self, *args, cwd=None):
        return subprocess.run(
            ["sh", "-c", '. "$1"; shift; git_commit "$@"', "test", str(HELPER), *args],
            cwd=cwd or self.repo, env=self.env, text=True, capture_output=True,
        )

    def test_defaults_to_current_repo_and_keeps_branch(self):
        (self.repo / "file").write_text("change")
        result = self.commit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.git("branch", "--show-current"), "feature")
        self.assertEqual(self.git("status", "--porcelain"), "")

    def test_explicit_subdirectory_stages_entire_repository(self):
        subdir = self.repo / "sub directory"
        subdir.mkdir()
        (subdir / "inside").write_text("inside")
        (self.repo / "outside").write_text("outside")
        result = self.commit(str(subdir), cwd="/")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.git("ls-tree", "-r", "--name-only", "HEAD").splitlines(),
                         ["outside", "sub directory/inside"])

    def test_includes_staged_changes_and_skips_unchanged_commit(self):
        (self.repo / "file").write_text("staged")
        self.git("add", "file")
        result = self.commit()
        self.assertEqual(result.returncode, 0, result.stderr)
        head = self.git("rev-parse", "HEAD")
        result = self.commit()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("No changes to commit", result.stdout)
        self.assertEqual(self.git("rev-parse", "HEAD"), head)

    def test_invalid_directory_and_extra_arguments(self):
        self.assertNotEqual(self.commit("/nonexistent/git-commit-test").returncode, 0)
        self.assertNotEqual(self.commit("one", "two").returncode, 0)

    def test_commit_failure_returns_to_caller(self):
        (self.repo / "file").write_text("change")
        hook = self.repo / ".git/hooks/pre-commit"
        hook.write_text("#!/bin/sh\nexit 1\n")
        hook.chmod(0o755)
        result = subprocess.run(
            ["sh", "-c", '. "$1"; git_commit; result=$?; echo survived; exit "$result"',
             "test", str(HELPER)], cwd=self.repo, env=self.env,
            text=True, capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("survived", result.stdout)


if __name__ == "__main__":
    unittest.main()
