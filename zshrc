# --- completions ---
# Homebrew’s zsh completions
fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -Uz compinit
compinit
# (optional niceties)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PATH=$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$(brew --prefix)/opt/util-linux/bin:$HOME/bin:/opt/homebrew/bin:/opt/homebrew/opt/libpq/bin:/usr/local/bin/:$HOME/code/welcomehome/bin:~/code/playbook/bin:~/code/playbook/contrib:$PATH

export BASH_ENV=~/.bash_env
export XDG_CONFIG_HOME="$HOME/.config"

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

command -v mise &>/dev/null && eval "$(mise activate bash)"
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

source "$(brew --prefix)"/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh   # auto-generated config, if present

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases


export COLORTERM=truecolor
export OLLAMA_API_BASE="http://localhost:11434"

export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"
