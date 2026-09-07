echo "Installing Podman..."
./install-podman.sh

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "Installing build tools (gcc)..."
sudo apt install build-essential

echo "Installing topgrade..."
cargo install topgrade

echo "Running Uptime Kuma..."
podman run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma docker.io/louislam/uptime-kuma:2
