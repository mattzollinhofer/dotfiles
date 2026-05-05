# load .envrc files in directories
export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)" 2>/dev/null

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- completions ---
if command -v brew &>/dev/null; then
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi

autoload -Uz compinit
compinit
# (optional niceties)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

if command -v brew &>/dev/null; then
    BREW_PREFIX="$(brew --prefix)"
    PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${BREW_PREFIX}/opt/util-linux/bin:${BREW_PREFIX}/opt/postgresql@17/bin:${BREW_PREFIX}/opt/libpq/bin:${BREW_PREFIX}/bin:${PATH}"
    unset BREW_PREFIX
fi
PATH="$HOME/bin:/usr/local/bin:$HOME/code/welcomehome/bin:$HOME/code/playbook/bin:$HOME/code/playbook/contrib:$PATH"

export BASH_ENV=~/.bash_env
export XDG_CONFIG_HOME="$HOME/.config"

# Load GNU tool aliases for consistent environment
[[ -f ~/.bash_env ]] && source ~/.bash_env

# Load secrets (API tokens, credentials)
[[ -f ~/.secrets ]] && source ~/.secrets

# fzf
# catppuccin for fzf
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
  --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
  --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
source <(fzf --zsh)
[[ -f ~/.fzf-git/fzf-git.sh ]] && source ~/.fzf-git/fzf-git.sh

command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# Load powerlevel10k theme if available
if command -v brew &>/dev/null && [[ -f "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh   # auto-generated config, if present

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases


export COLORTERM=truecolor
export OLLAMA_API_BASE="http://localhost:11434"

export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"

# Load local machine-specific configuration
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
