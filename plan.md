# Dotfiles Portability Audit Plan

## Objective
Comprehensively audit all configuration files in the dotfiles repository to identify:
- Missing dependencies and installation steps
- Secondary config files we may have overlooked
- Hardcoded paths or non-portable configurations
- Tool-specific setup requirements not documented
- External dependencies (binaries, plugins, etc.)

## Tools/Configs to Audit

### 1. Neovim (`config/nvim/`)
- [ ] Check `init.lua` for:
  - Plugin manager (lazy.nvim) - does it auto-bootstrap?
  - LSP servers referenced (need Mason or manual install?)
  - External binaries (ripgrep, fd, etc.)
  - Treesitter parsers
  - Any hardcoded paths beyond what we fixed
  - Custom Lua modules in `lua/` directory
- [ ] Check `lazy-lock.json` - are all plugins portable?
- [ ] Check `after/ftplugin/` for language-specific deps
- [ ] Custom snippets in `lua/snippets/` - any dependencies?

### 2. Tmux (`config/tmux/`)
- [ ] Check for plugin manager (tpm) references
- [ ] Custom scripts in `scripts/` directory
- [ ] External binary dependencies
- [ ] Hardcoded paths

### 3. Git (`config/git/`, `gitconfig`)
- [ ] Check `config/git/ignore` for anything non-standard
- [ ] Verify all git aliases in `gitconfig` work without external tools
- [ ] Check if any aliases reference scripts/binaries

### 4. Lazygit (`config/lazygit/`)
- [ ] Check config.yml for external dependencies
- [ ] Custom commands that need binaries

### 5. Karabiner (`config/karabiner/`)
- [ ] Complex modifications referencing external scripts?
- [ ] macOS-specific - document as such

### 6. GitHub CLI (`config/gh/`)
- [ ] Check config.yml and hosts.yml for completeness
- [ ] Any extensions that need separate install?

### 7. Mise (`config/mise/`)
- [ ] Check config.toml for tool installations
- [ ] Document which tools mise manages vs manual install

### 8. Shell Configs
- [ ] `zshrc` - already checked, but verify:
  - All sourced files exist or have conditional checks
  - All tools have conditional activation
  - PATH modifications reference portable locations
- [ ] `aliases` - check for commands that assume tools exist
- [ ] `bash_env` - GNU tools documented in README?

### 9. Other Configs
- [ ] `.pryrc` - Ruby dependencies?
- [ ] `CLAUDE.md` - any tool references to document?

## Specific Checks

### Hardcoded Paths
- [ ] Grep for `/Users/z-dev` (should be none)
- [ ] Grep for hardcoded `/opt/homebrew` vs `$(brew --prefix)`
- [ ] Check for `~` vs `$HOME`

### External Dependencies
- [ ] List all `brew install` needed
- [ ] List all tools assumed to exist (ripgrep, fd, etc.)
- [ ] List all language-specific tools (LSPs, formatters)

### Missing Setup Steps
- [ ] Plugin managers that need initialization
- [ ] First-run setup scripts
- [ ] Tool-specific authentication/config

### Referenced Files Not in Repo
- [ ] Look for `source` statements pointing to missing files
- [ ] Look for config includes pointing to missing files
- [ ] Check for `.local` file patterns we need to document

## Deliverables

1. **Complete dependency list** organized by:
   - Required (breaks without it)
   - Optional (degrades gracefully)
   - Auto-installed by install.sh

2. **Missing setup steps** to add to install.sh or document in README

3. **Portability issues** that need fixing

4. **Updated README** with complete dependency documentation
