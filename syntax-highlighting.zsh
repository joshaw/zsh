# Source module files.
source "${HOME}/.zsh/syntax/zsh-syntax-highlighting.zsh"

is_cygwin() {
	local uname
	# Check we're running under cygwin
	uname=`uname -s`
	[[ $uname[0,6] == 'CYGWIN' ]]
}

if is_cygwin; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
else
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
fi
