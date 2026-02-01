#!/usr/bin/env bash
# Linux-specific installations for packages not in apt
# Run after: xargs -a packages.apt sudo apt install -y

set -e

echo "Installing Linux-specific packages..."

# GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

# Starship prompt
if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# fnm (Fast Node Manager)
if ! command -v fnm &> /dev/null; then
    echo "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# pnpm
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# sesh (tmux session manager)
if ! command -v sesh &> /dev/null; then
    echo "Installing sesh..."
    # sesh requires Go, check if available
    if command -v go &> /dev/null; then
        go install github.com/joshmedeski/sesh@latest
    else
        echo "Warning: Go not installed, skipping sesh. Install Go first or install sesh manually."
    fi
fi

# Ghostty (if available for Linux)
if ! command -v ghostty &> /dev/null; then
    echo "Note: Ghostty installation on Linux varies. Check https://ghostty.org for instructions."
fi

echo "Linux installation complete!"
echo ""
echo "Manual steps you may need:"
echo "  1. Install Nerd Fonts: https://www.nerdfonts.com/"
echo "  2. Set fish as default shell: chsh -s \$(which fish)"
echo "  3. Install Ghostty from source or package if available"
