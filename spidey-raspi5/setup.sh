echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "Installing build tools (gcc)..."
sudo apt install build-essential

echo "Installing topgrade..."
cargo install topgrade
