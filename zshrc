export DOTFILES="$HOME/dotfiles"

# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt incappendhistory
setopt sharehistory

setopt autocd extendedglob nomatch notify
# Fix issue using carrot in git refs
setopt NO_NOMATCH

unsetopt beep
bindkey -e
bindkey "^R" history-incremental-search-backward

zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit

# Load color names and allow expansion for prompt
setopt prompt_subst
autoload -U colors && colors

# Prompt with git info
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
# GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="verbose"
precmd () { __git_ps1 "[%{$fg_no_bold[blue]%}%~%{$reset_color%}" "]$ " " (%s)" }

# Editor
export VISUAL=vim
export EDITOR=vim

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Must occur after local config for aliases
#eval `dircolors ~/.dir_colors`


export PATH="./bin:$PATH" # Add current bin for easier rails dev
source /Users/matt/.asdf/asdf.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
