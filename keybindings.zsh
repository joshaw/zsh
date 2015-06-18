 # Created:  Tue 15 Oct 2013
# Modified: Wed 17 Jun 2015
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

# ctrl-z back to eg vim
function fancy-ctrl-z() {
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
