# Created:  Tue 15 Oct 2013
# Modified: Wed 21 Jan 2015
# Author:   Josh Wainwright
# Filename: .zlogin
#
# Executes commands at login post-zshrc.
#

# Execute code that does not affect the current session in the background.
{
	# Compile the completion dump to increase startup speed.
	zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
	if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
		zcompile "$zcompdump"
	fi
} &!

export ZSH_SHLVL_INIT=0
