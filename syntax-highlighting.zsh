# Created:  Tue 15 Oct 2013
# Modified: Sat 25 Apr 2015
# Author:   Josh Wainwright
# Filename: syntax-highlighting.zsh

is_cygwin() {
	# Check we're running under cygwin
	# local uname=`uname -s`
	# [[ $uname[0,6] == 'CYGWIN' ]]
	[[ $OSTYPE == 'cygwin' ]]
}

if ! is_cygwin; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor root line)
	source "${HOME}/.zsh/syntax/zsh-syntax-highlighting.zsh"
fi
