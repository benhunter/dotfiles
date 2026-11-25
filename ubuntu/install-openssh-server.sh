#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y openssh-server
sudo systemctl enable --now ssh.socket
systemctl is-active ssh.socket

printf 'Host IP addresses: %s\n' "$(hostname -I)"
if ! command -v ufw >/dev/null 2>&1; then
    printf 'UFW is not installed; no firewall rules were changed.\n'
elif ! ufw_status=$(sudo env LC_ALL=C ufw status); then
    printf 'Could not check UFW status; no firewall rules were changed.\n' >&2
elif ! grep -qx 'Status: active' <<< "$ufw_status"; then
    printf 'UFW is not active; no firewall rules were changed.\n'
elif [[ -t 0 ]] && read -r -p 'UFW is active. Allow SSH from any IP address? [y/N] ' answer && [[ $answer =~ ^([yY]|[yY][eE][sS])$ ]]; then
    sudo ufw allow OpenSSH
else
    printf 'UFW is active; no firewall rules were changed.\n'
fi
