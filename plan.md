# Dotfiles Portability Audit Plan

## Objective Comprehensively update our dotfiles. We'll need to audit all
configuration files in the dotfiles repository to identify:
- Missing dependencies and installation steps
- Secondary config files we may have overlooked
- Hardcoded paths or non-portable configurations
- Tool-specific setup requirements not documented
- External dependencies (binaries, plugins, etc.)

## Tools/Configs to Audit

### 1. Neovim (`config/nvim/`)
- [x] Check `init.lua` for:
  - [x] Plugin manager (lazy.nvim) - Auto-bootstraps on first run (lines 13-21)
  - [x] LSP servers - `ruby-lsp` (line 670) requires `gem install ruby-lsp`
  - [x] External binaries required:
    - `fd` (line 400) - Telescope file finder
    - `ripgrep` - Telescope live_grep
    - `git` - Fugitive, gitsigns, telescope
    - `rubocop` (line 1202) - Ruby auto-format
    - `make` (line 386) - telescope-fzf-native build
    - `npm` (line 850) - markdown-preview build
  - [x] Treesitter parsers - Auto-installed via `:TSUpdate` (lines 607-619)
  - [x] Hardcoded paths - `~/working-notes` (995), `~/code/playbook` (998) are user-specific
  - [x] Custom Lua modules - `ff_pins.lua` (depends on `fd` or `find`, uses `git`)
- [x] Check `lazy-lock.json` - Exists, plugins are portable
- [x] Check `after/ftplugin/` - Only `ruby.vim` with simple keybind, no deps
- [x] Custom snippets - `ruby.lua` uses LuaSnip, no external deps

### 2. Tmux (`tmux.conf` at root)
- [x] Added to install.sh symlinks
- [x] Removed deprecated `bell-on-alert` option for tmux 3.x compatibility
- [x] Check for plugin manager (tpm) references - No tpm used
- [x] Custom scripts in `scripts/` directory - None
- [x] External binary dependencies - Only `is-online` script (line 117)
- [x] Hardcoded paths - Uses ~/.tmux.conf throughout (portable)

### 3. Git (`config/git/`, `gitconfig`)
- [ ] Check `config/git/ignore` for anything non-standard
- [ ] Verify all git aliases in `gitconfig` work without external tools
- [ ] Check if any aliases reference scripts/binaries

### 4. Lazygit (`config/lazygit/`)
- [ ] Check config.yml for external dependencies
- [ ] Custom commands that need binaries

### 5. Karabiner (`config/karabiner/`)
- [x] Complex modifications referencing external scripts? - No external scripts
- [x] macOS-specific - document as such - Yes, macOS only
- [x] Device-specific configs standardized - Moved to global simple_modifications

### 6. GitHub CLI (`config/gh/`)
- [ ] Check config.yml and hosts.yml for completeness
- [ ] Any extensions that need separate install?

### 7. Mise (`config/mise/`)
- [x] Check config.toml for tool installations - Manages Node 20.11.1, Ruby 3.3.0
- [x] Document which tools mise manages vs manual install - mise/asdf are equivalent and interchangeable
- [x] Note: zshrc only conditionally activates mise, NOT asdf - need to add asdf support

### 8. Shell Configs
- [x] `zshrc` - verified:
  - All sourced files exist or have conditional checks
  - All tools have conditional activation (mise, atuin, fzf)
  - PATH modifications reference portable locations
  - Missing: asdf support (only checks for mise)
- [x] `aliases` - Audited tool dependencies:
  - All required tools already in install.sh (nvim, lazygit, fzf, watchexec)
  - One GNU tool: gtruncate (line 75) - already documented in README
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
