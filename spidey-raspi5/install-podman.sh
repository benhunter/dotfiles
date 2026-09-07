#!/usr/bin/env bash
set -euo pipefail

echo "[+] Updating system"
sudo apt update

echo "[+] Installing Podman and required dependencies"
sudo apt install -y \
  podman \
  uidmap \
  slirp4netns \
  fuse-overlayfs \
  podman-compose

echo "[+] Ensuring subuid/subgid mappings exist for rootless containers"

USER_NAME="${SUDO_USER:-$USER}"

ensure_subid() {
  local file="$1"
  local user="$2"

  if ! grep -q "^${user}:" "$file"; then
    echo "[+] Adding $user to $file"
    sudo usermod \
      --add-subuids 100000-165536 \
      --add-subgids 100000-165536 \
      "$user"
  else
    echo "[=] $user already present in $file"
  fi
}

ensure_subid /etc/subuid "$USER_NAME"
ensure_subid /etc/subgid "$USER_NAME"

echo "[+] Enabling user lingering for systemd (allows containers to run after logout)"
sudo loginctl enable-linger "$USER_NAME"

echo "[+] Setting Podman to use fuse-overlayfs for rootless storage"
mkdir -p "$HOME/.config/containers"

cat > "$HOME/.config/containers/storage.conf" <<'EOF'
[storage]
driver = "overlay"

[storage.options]
mount_program = "/usr/bin/fuse-overlayfs"
EOF

echo "[+] Verifying Podman installation"
podman info --format '{{.Host.OCIRuntime.Name}}'

echo
echo "[✓] Podman installation complete"
echo "    IMPORTANT: Log out and log back in for subuid/subgid changes to take effect."
echo "    Test with: podman run --rm hello-world"
