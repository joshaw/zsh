bindkey -e
bindkey ';5D' backward-word
bindkey ';5C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line


# Increment the last number, with 0 padding, by +1 or -1.
_increase_number() {
  local -a match mbegin mend
  [[ $LBUFFER =~ '([0-9]+)[^0-9]*$' ]] &&
    LBUFFER[mbegin,mend]=$(printf %0${#match[1]}d $((10#$match+${NUMERIC:-1})))
}
zle -N increase-number _increase_number
bindkey '^Xa' increase-number
bindkey -s '^Xx' '^[-^Xa'


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
