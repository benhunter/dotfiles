#!/usr/bin/env bash
set -euo pipefail

### Config (toggle defaults via flags)
WITH_CALIBRATION="false"
AUTO_REBOOT="true"

usage() {
  cat <<USAGE
Usage: $0 [--with-calibration] [--no-reboot]

  --with-calibration   Also install xinput-calibrator (for touch alignment)
  --no-reboot          Do not reboot automatically when finished

Examples:
  sudo $0 --with-calibration
USAGE
}

# Parse flags
while [[ "${1:-}" != "" ]]; do
  case "$1" in
    --with-calibration) WITH_CALIBRATION="true" ;;
    --no-reboot)        AUTO_REBOOT="false" ;;
    -h|--help)          usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Please run as root: sudo $0 $*" >&2
    exit 1
  fi
}

trap 'echo "[!] Failed at line $LINENO"; exit 1' ERR

require_root

echo "[+] Verifying environment…"

# Basic OS/arch sanity checks (warn only; continue if they don't match exactly)
ARCH="$(uname -m || true)"
ID="$(. /etc/os-release && echo "${ID:-}")"
VERSION_CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-}")"

if [[ "${ID}" != "ubuntu" ]]; then
  echo "[!] This script targets Ubuntu. Detected: ${ID:-unknown}. Proceeding anyway…"
fi
if [[ "${VERSION_CODENAME}" != "noble" ]]; then
  echo "[!] Expected Ubuntu 24.04 (noble). Detected: ${VERSION_CODENAME:-unknown}. Proceeding anyway…"
fi
if [[ "${ARCH}" != "aarch64" && "${ARCH}" != "arm64" ]]; then
  echo "[!] Expected ARM64 (Raspberry Pi 5). Detected: ${ARCH}. Proceeding anyway…"
fi

# Quick network check
if ! ping -c1 -W2 archive.ubuntu.com >/dev/null 2>&1; then
  echo "[!] Network/apt mirror not reachable. Check networking and try again." >&2
  exit 1
fi

echo "[+] Refreshing apt and upgrading base system…"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade

echo "[+] Installing lightweight desktop (LXQt) and display manager (SDDM)…"
# Ensure Xorg is present explicitly (sometimes not pulled automatically)
# Keep recommends minimal for a lighter footprint.
apt-get install -y --no-install-recommends \
  xorg \
  lxqt \
  sddm

# Some helpful basics for a smoother desktop experience (still light)
apt-get install -y \
  lxqt-policykit \
  network-manager-gnome \
  gvfs

# Preselect SDDM as the default display manager (non-interactive)
if command -v debconf-communicate >/dev/null 2>&1; then
  echo "sddm shared/default-x-display-manager select sddm" | debconf-set-selections || true
fi
dpkg-reconfigure -f noninteractive sddm || true

# Optional: touchscreen calibration tool
if [[ "${WITH_CALIBRATION}" == "true" ]]; then
  echo "[+] Installing touchscreen calibration tool…"
  apt-get install -y xinput-calibrator
fi

echo "[+] Enabling graphical boot (graphical.target)…"
systemctl set-default graphical.target

# SDDM should start on boot automatically, ensure it is enabled
systemctl enable sddm.service

echo "[+] Done. Desktop environment installed: LXQt + SDDM"
if [[ "${WITH_CALIBRATION}" == "true" ]]; then
  cat <<'TIP'
[Touchscreen calibration]
After login to the desktop, open a terminal and run:
  xinput_calibrator
Follow the on-screen steps; it will print an xorg snippet to save under:
  /etc/X11/xorg.conf.d/99-calibration.conf  (create directory if needed)
TIP
fi

if [[ "${AUTO_REBOOT}" == "true" ]]; then
  echo "[+] Rebooting now to start the graphical session…"
  sleep 2
  reboot
else
  echo "[i] Skipping reboot (--no-reboot given). You can start the GUI with:"
  echo "    sudo systemctl isolate graphical.target"
  echo "    # or just reboot: sudo reboot"
fi
