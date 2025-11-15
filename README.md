# Dotfiles

Personal configuration files for shell, editor, and development tools.

## Quick Start

```bash
# Clone to hidden directory
git clone git@github.com:mattzollinhofer/dotfiles.git ~/.dotfiles

# Run install script
~/.dotfiles/install.sh

# Set up secrets file
cp ~/.dotfiles/.secrets.example ~/.secrets
chmod 600 ~/.secrets
# Edit ~/.secrets and add your actual tokens
```

## What Gets Installed

### Shell Configs (symlinked to ~/)
- `.zshrc` - zsh configuration with powerlevel10k
- `.aliases` - git workflow and utility aliases
- `.gitconfig` - git configuration and aliases
- `.bash_env` - GNU tool aliases (overrides macOS defaults)
- `.gitignore_global` - global git ignore patterns

### Application Configs (symlinked to ~/.config/)
- `nvim/` - Neovim configuration
- `tmux/` - tmux configuration
- `git/` - git config directory
- `lazygit/` - git TUI configuration
- `karabiner/` - keyboard customization
- `gh/` - GitHub CLI config
- `mise/` - dev environment manager
- `CLAUDE.md` - Claude Code instructions
- `.pryrc` - Ruby REPL configuration

## Required Setup After Install

### 1. Secrets File
The install script does NOT create `~/.secrets`. You must:

```bash
cp ~/.dotfiles/.secrets.example ~/.secrets
chmod 600 ~/.secrets
```

Then edit `~/.secrets` and add your actual API tokens and machine-specific paths.

### 2. Dependencies
Install required tools:
- `nvim` - editor
- `tmux` - terminal multiplexer
- `mise` - dev environment manager
- GNU coreutils (ggrep, gdate, gawk) - `brew install coreutils gawk`
- `fzf` - fuzzy finder
- `gh` - GitHub CLI

### 3. Font (Optional)
Install a Nerd Font for proper icon rendering in nvim:
```bash
brew install --cask font-meslo-lg-nerd-font
```

## Security

### Never Committed
- API tokens (stored in `~/.secrets`)
- SSH keys (`~/.ssh/`)
- AWS credentials (`~/.config/aws/`)
- Shell history (`~/.config/atuin/`)
- Tool-specific tokens (`~/.config/prr/`, `~/.config/shortcut-cli/`)

### See Also
- `.gitignore` - patterns blocked from repo
- `~/.gitignore_global` - patterns blocked from all git repos

## Structure

```
~/.dotfiles/
├── config/              # ~/.config items
│   ├── nvim/
│   ├── tmux/
│   ├── CLAUDE.md
│   └── ...
├── zshrc                # Shell configs at root
├── aliases
├── gitconfig
├── bash_env
├── install.sh           # Setup script
└── .secrets.example     # Template for secrets
```

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-runs symlink creation (backs up existing files)
```

## Notes

- Old vimrc files still present but unused (migrated to nvim)
- VS Code configs (settings.json, keybindings.json) still present
- install.sh backs up existing files with timestamp before symlinking
