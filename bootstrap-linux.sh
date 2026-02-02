#!/usr/bin/env bash
# Bootstrap script for fresh Linux servers
# Run as root: curl -fsSL <raw-url> | bash
#
# This script:
# 1. Creates the wking user with sudo access
# 2. Sets up the home directory structure
# 3. Clones dotfiles and runs install as wking

set -e

USERNAME="wking"
DOTFILES_REPO="git@github.com:wking-io/dotfiles.git"
DOTFILES_HTTPS="https://github.com/wking-io/dotfiles.git"

echo "=== Linux Server Bootstrap ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root"
    echo "Usage: sudo bash bootstrap-linux.sh"
    exit 1
fi

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    apt update && apt install -y git
fi

# Create user if doesn't exist
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists"
else
    echo "Creating user $USERNAME..."
    useradd -m -s /bin/bash "$USERNAME"
fi

# Ensure home directory ownership
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME"

# Add to sudo group
echo "Adding $USERNAME to sudo group..."
usermod -aG sudo "$USERNAME" 2>/dev/null || usermod -aG wheel "$USERNAME" 2>/dev/null || true

# Create sudoers entry for passwordless sudo
echo "Setting up passwordless sudo..."
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USERNAME"
chmod 440 "/etc/sudoers.d/$USERNAME"

# Validate sudoers syntax
if ! visudo -c &>/dev/null; then
    echo "Error: Invalid sudoers syntax"
    rm -f "/etc/sudoers.d/$USERNAME"
    exit 1
fi

# Create standard directories
echo "Creating directory structure..."
sudo -u "$USERNAME" mkdir -p \
    "/home/$USERNAME/.claude" \
    "/home/$USERNAME/.local/bin" \
    "/home/$USERNAME/.config" \
    "/home/$USERNAME/.cache" \
    "/home/$USERNAME/Code"

# Clone dotfiles
DOTFILES_DIR="/home/$USERNAME/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles already exist at $DOTFILES_DIR"
else
    echo "Cloning dotfiles..."
    # Try SSH first, fall back to HTTPS
    if sudo -u "$USERNAME" git clone "$DOTFILES_REPO" "$DOTFILES_DIR" 2>/dev/null; then
        echo "Cloned via SSH"
    else
        echo "SSH failed, trying HTTPS..."
        sudo -u "$USERNAME" git clone "$DOTFILES_HTTPS" "$DOTFILES_DIR"
    fi
fi

# Run dotfiles install as wking
echo ""
echo "Running dotfiles install..."
cd "$DOTFILES_DIR"
sudo -u "$USERNAME" ./install

echo ""
echo "=== Bootstrap Complete ==="
echo ""
echo "User '$USERNAME' is ready. Switch to it with:"
echo "  su - $USERNAME"
echo ""
echo "Or reconnect via SSH as $USERNAME"
