setopt NO_CASE_GLOB
setopt AUTO_CD

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
SAVEHIST=5000
HISTSIZE=2000
# share across multiple zsh sessions
setopt SHARE_HISTORY
setopt APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
