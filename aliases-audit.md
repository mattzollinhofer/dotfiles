# Shell Aliases Portability Audit

## External Tool Dependencies

### Critical (aliases will fail without these)

**git** - Required
- Lines 1, 10-41: Nearly all git aliases
- Status: Should always be present, but not checked

**nvim** - Required
- Lines 2-6: vi, vim, nv, v, vv aliases
- Status: Auto-installed by install.sh ✅

**fzf** - Required for fuzzy finding
- Lines 33-37: gls, gcf, gcz, gbf, gbz (fuzzy checkout)
- Status: Auto-installed by install.sh ✅
- Impact: 5 aliases depend on it

**lazygit** - Required
- Line 22: glg alias
- Status: Auto-installed by install.sh ✅
- Impact: 1 alias depends on it

**grep** - Required (but system default ok)
- Lines 43, 50: psg, hg aliases
- Status: System command, portable ✅

**gtruncate** (GNU coreutils)
- Line 77: truncate alias
- Status: Requires `brew install coreutils` - documented in README ✅

### Project-Specific (will fail outside specific repos)

**bundle/rails** - Ruby/Rails projects only
- Lines 7, 8, 51, 62: be, console, rc, review_app_console
- Status: Project-specific, acceptable ✅

**heroku CLI**
- Line 62: review_app_console
- Status: Not documented, but project-specific ⚠️

**watchexec**
- Lines 69-76: wrt alias/function
- Status: Auto-installed by install.sh ✅

**rbw** (Bitwarden CLI for mfa alias)
- Line 57: mfa alias
- Status: Personal tool, not documented ⚠️

### Path-Specific Issues

**Hardcoded paths:**
- Line 56: `~/alfred/todos` - personal directory ⚠️
- Line 57: `~/code/playbook/bin/aws-perform-mfa` - personal repo path ⚠️
- Lines 64-65: `cx-rails-console` - custom command, location unknown ⚠️

## Summary

### Missing from install.sh
- [x] **fzf** - CRITICAL - used by 5 aliases
- [x] **lazygit** - used by 1 alias
- [x] **watchexec** - used by 1 alias

### Missing from README dependencies
- [ ] fzf (documented but says "fuzzy finder" - should note aliases depend on it)
- [ ] lazygit (not mentioned at all)
- [ ] watchexec (not mentioned)
- [ ] heroku CLI (project-specific, maybe skip)

### Personal/Non-Portable Aliases
Lines 56-65 contain personal paths and project-specific aliases:
- `todo` - hardcoded ~/alfred/todos
- `mfa` - hardcoded ~/code/playbook path
- `cxs`, `cxp` - custom commands
- These are fine to keep but could be moved to `.aliases.local`

## Recommendations

### High Priority
- [x] **Add fzf to install.sh** - 5 aliases depend on it
- [x] **Add lazygit to install.sh** - config already present, just need binary
- [x] **Add watchexec to install.sh** or document as optional

### Medium Priority
- [ ] **Update README** to clearly mark which tools aliases depend on

### Low Priority
- [ ] **Move personal aliases to .aliases.local** (lines 56-58, 64-65)
   - Keep them in repo but comment out with note to customize
   - Or add to .aliases.local.example
- [ ] **Add git availability check** (probably overkill, git always present on dev machines)

## Files to Update

- [x] **install.sh** - add fzf, lazygit, watchexec
- [ ] **README.md** - document these as alias dependencies
- [ ] **aliases** - optionally comment out personal paths
