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
for file in zshrc aliases aliases.local gitconfig gemrc bash_env gitignore_global; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/.$file"
    fi
done

echo ""
echo "Done! Dotfiles installed."
echo "Note: Some configs (prr, shortcut-cli, atuin, iterm2) are excluded for security."
