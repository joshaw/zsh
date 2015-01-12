# Created:  Wed 15 Oct 2014
# Modified: Mon 12 Jan 2015
# Author:   Josh Wainwright
# Filename: syntax-highlighting.zsh
#
# Source module files.

is_cygwin() {
	# Check we're running under cygwin
	# local uname=`uname -s`
	# [[ $uname[0,6] == 'CYGWIN' ]]
	[[ $OSTYPE == 'cygwin' ]]
}

if ! is_cygwin; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
	source "${HOME}/.zsh/syntax/zsh-syntax-highlighting.zsh"
fi

zsh_timing_function ${(%):-%N}
