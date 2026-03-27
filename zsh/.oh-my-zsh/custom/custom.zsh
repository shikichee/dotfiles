# ENV
## [GKE]
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# PATH
export PATH=$HOME/.opencode/bin:$PATH

# SHELL OPTIONS
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups
setopt share_history
setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt nolistbeep

# HISTORY SEARCH (Ctrl+P/N)
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ALIASES
unalias gg 2>/dev/null
unalias gga 2>/dev/null
alias gg='git grep -in --break'
alias gps='git push origin HEAD'

alias c='cursor .'
alias cl='claude'
alias clp='claude --permission-mode auto'
alias clpd='claude-private --dangerously-skip-permissions'
alias clpdw='clpd --worktree'

alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# FUNCTIONS

## after cd command, execute l
function cd() {
  builtin cd $@ && l;
}

## history-all
function history-all { history -E 1 }

## [ghq]
function repo() {
  cd $(ghq list -p | fzf -q ""$@"")
}

function clone() {
  ghq get -p $@ && cd $(ghq list -p | grep $@);
}

function sclone() {
  clone shikichee/$@;
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# status line
eval "$(starship init zsh)"

# load local settings
if [ -f ~/.local.zsh ]; then
	. ~/.local.zsh
fi
