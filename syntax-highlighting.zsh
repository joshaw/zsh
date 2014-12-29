# Source module files.
source "${HOME}/.zsh/syntax/zsh-syntax-highlighting.zsh"

is_cygwin() {
	# Check we're running under cygwin
	local uname=`uname -s`
	[[ $uname[0,6] == 'CYGWIN' ]]
}

if is_cygwin; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
else
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
fi

zsh_timing_function ${(%):-%N}
