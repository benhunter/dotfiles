#!/bin/sh
# Install Helm

SCRIPT="/tmp/get_helm.sh"
curl -fsSL -o $SCRIPT https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 $SCRIPT
$SCRIPT
