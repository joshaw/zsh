# Created:  Tue 15 Oct 2013
# Modified: Tue 24 Feb 2015
# Author:   Josh Wainwright
# Filename: keybindings.zsh

bindkey -e
bindkey ';5D' backward-word
bindkey ';5C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^B' push-line

bindkey ' ' magic-space

autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward
{
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

bindkey '[A' history-substring-search-up
bindkey '[B' history-substring-search-down

# ctrl-z back to eg vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
