# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal configuration directory (`~/.config`) containing dotfiles and settings for various development tools and applications on macOS.

## Key Configurations

### Neovim (`nvim/`)
- **Main config**: `nvim/init.lua` - comprehensive Neovim setup with LSP, completion, and plugins
- **Plugin manager**: lazy.nvim
- **Theme**: Catppuccin (latte flavor) 
- **Key features**:
  - Telescope for fuzzy finding
  - Mini.nvim suite for various utilities
  - Git integration via Fugitive and LazyGit
  - Treesitter for syntax highlighting
  - Custom snippets in `lua/snippets/`
  - Ruby LSP with ruby-lsp server

### Git (`gh/`, `git/`)
- **gh CLI**: configured with HTTPS protocol, aliases (`co: pr checkout`)
- **lazygit**: minimal config with half-screen mode

### Other Tools
- **karabiner**: keyboard customization (complex JSON config)
- **iterm2**: terminal configuration 
- **flameshot**: screenshot tool settings
- **mise**: development environment manager
- **shortcut-cli**: productivity shortcuts

## Development Workflow

Based on the Neovim configuration, the primary development workflow appears to be:
- Ruby/Rails development with tag and LSP support
- Git workflow heavily integrated (Fugitive + LazyGit)
- Telescope for file navigation and search
- Tmux integration for terminal multiplexing
- Working notes directory at `~/working-notes`

## Key Keybindings (Neovim)

- Leader key: `<Space>`

## Architecture Notes

- Configuration follows a modular approach with lazy-loading plugins
- Ruby development is the primary focus
- Git workflow is heavily customized with both command-line and GUI options
- File navigation emphasizes git-aware fuzzy finding
- Custom text objects and keybindings for productivity
