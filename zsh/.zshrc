# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
COMPLETION_WAITING_DOTS="true"
ZSH_DISABLE_COMPFIX="true"

plugins=(git fzf mise gcloud kubectl kubectx)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR=nvim
export LANG=ja_JP.UTF-8
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/.local/bin

# Claude worktree helpers
cwt() {
  local project_root
  project_root=$(git rev-parse --show-toplevel 2>/dev/null)
  # If inside a worktree, go up to the main repo
  if [[ "$project_root" == */.claude/worktrees/* ]]; then
    project_root=$(echo "$project_root" | sed 's|/.claude/worktrees/.*||')
  fi

  local wt_dir="${project_root}/.claude/worktrees"
  if [[ ! -d "$wt_dir" ]]; then
    echo "No worktrees found in ${wt_dir}"
    return 1
  fi

  local dirs=("${wt_dir}"/*(N/))
  if [[ ${#dirs} -eq 0 ]]; then
    echo "No worktrees found"
    return 1
  fi

  if [[ "$1" == "-l" || "$1" == "--list" ]]; then
    for d in "${dirs[@]}"; do
      local name=$(basename "$d")
      local branch=$(git -C "$d" branch --show-current 2>/dev/null)
      printf "  %-20s %s\n" "$name" "$branch"
    done
    return 0
  fi

  if [[ -n "$1" ]]; then
    if [[ -d "${wt_dir}/$1" ]]; then
      cd "${wt_dir}/$1"
    else
      echo "Worktree '$1' not found"
      return 1
    fi
  else
    local selected=$(printf '%s\n' "${dirs[@]}" | xargs -I{} basename {} | fzf --prompt="worktree> ")
    [[ -n "$selected" ]] && cd "${wt_dir}/${selected}"
  fi
}

# Back to main repo from worktree
cwtm() {
  local current=$(pwd)
  if [[ "$current" == */.claude/worktrees/* ]]; then
    cd "$(echo "$current" | sed 's|/.claude/worktrees/.*||')"
  else
    echo "Not in a worktree"
  fi
}

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/shikicheep/.lmstudio/bin"
# End of LM Studio CLI section

