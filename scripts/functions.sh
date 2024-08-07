git_commit() {
  # Update git repo
  git -C $SCRIPT_DIR switch main

  # if pull fails, exit
  if ! git -C $SCRIPT_DIR pull; then
    echo "Pull failed. Exiting..."
    exit 1
  fi

  git -C $SCRIPT_DIR add -A
  git -C $SCRIPT_DIR commit -v
  git -C $SCRIPT_DIR push
}
