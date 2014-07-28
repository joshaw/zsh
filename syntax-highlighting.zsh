# Source module files.
source "${HOME}/.zsh/syntax/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

function pygmentize_cat {
  for arg in "$@"; do
    pygmentize -g "${arg}" 2> /dev/null || /bin/cat "${arg}"
  done
}
command -v pygmentize > /dev/null && alias ccat=pygmentize_cat
