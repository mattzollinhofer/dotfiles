#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

echo "Installing dotfiles from $DOTFILES_DIR"

# Backup function
backup_if_exists() {
    local target=$1
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing $target to $backup"
        mv "$target" "$backup"
    elif [ -L "$target" ]; then
        echo "Removing existing symlink $target"
        rm "$target"
    fi
}

# Create symlink function
create_symlink() {
    local source=$1
    local target=$2
    backup_if_exists "$target"
    echo "Linking $target -> $source"
    ln -s "$source" "$target"
}

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

# Symlink config directories
echo ""
echo "Setting up ~/.config symlinks..."
for dir in "$DOTFILES_DIR"/config/*/; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        create_symlink "$dir" "$CONFIG_DIR/$dirname"
    fi
done

# Symlink config files (at root of config/)
for file in "$DOTFILES_DIR"/config/.*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        create_symlink "$file" "$CONFIG_DIR/$filename"
    fi
done

for file in "$DOTFILES_DIR"/config/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        create_symlink "$file" "$CONFIG_DIR/$filename"
    fi
done

# Symlink shell configs from root
echo ""
echo "Setting up shell config symlinks..."
for file in zshrc aliases aliases.local gitconfig gemrc bash_env gitignore_global p10k.zsh tmux.conf; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/.$file"
    fi
done

# Install Homebrew packages
echo ""
echo "Installing Homebrew packages..."
if command -v brew &>/dev/null; then
    # Install powerlevel10k theme
    if ! brew list powerlevel10k &>/dev/null; then
        echo "Installing powerlevel10k..."
        brew install powerlevel10k
    else
        echo "powerlevel10k already installed"
    fi

    # Install Meslo Nerd Font
    if ! brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        echo "Installing Meslo LG Nerd Font..."
        brew install --cask font-meslo-lg-nerd-font
    else
        echo "Meslo LG Nerd Font already installed"
    fi

    # Install neovim
    if ! brew list neovim &>/dev/null; then
        echo "Installing neovim..."
        brew install neovim
    else
        echo "neovim already installed"
    fi

    # Install fzf (required by shell aliases)
    if ! brew list fzf &>/dev/null; then
        echo "Installing fzf..."
        brew install fzf
    else
        echo "fzf already installed"
    fi

    # Install lazygit (required by glg alias)
    if ! brew list lazygit &>/dev/null; then
        echo "Installing lazygit..."
        brew install lazygit
    else
        echo "lazygit already installed"
    fi

    # Install watchexec (required by wrt alias)
    if ! brew list watchexec &>/dev/null; then
        echo "Installing watchexec..."
        brew install watchexec
    else
        echo "watchexec already installed"
    fi
else
    echo "Warning: Homebrew not found. Skipping package installation."
    echo "Please install Homebrew from https://brew.sh"
fi

# Clone fzf-git if not present
echo ""
if [ ! -d "$HOME/.fzf-git" ]; then
    echo "Cloning fzf-git.sh..."
    git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/.fzf-git"
else
    echo "fzf-git.sh already installed"
fi

echo ""
echo "Done! Dotfiles installed."
echo "Note: Some configs (prr, shortcut-cli, atuin, iterm2) are excluded for security."
echo ""
echo "=========================================="
echo "⚠️  MANUAL STEP REQUIRED - Font Setup"
echo "=========================================="
echo "To see icons properly in your shell prompt, set your terminal font:"
echo ""
echo "iTerm2:"
echo "  1. Open Preferences (Cmd + ,)"
echo "  2. Go to Profiles → Text → Font"
echo "  3. Select 'MesloLGS Nerd Font Mono' (size 12-14 recommended)"
echo ""
echo "Terminal.app:"
echo "  1. Open Preferences (Cmd + ,)"
echo "  2. Go to Profiles → Font → Change"
echo "  3. Search for 'MesloLGS' and select 'MesloLGS Nerd Font Mono'"
echo "=========================================="
