#
# Executes commands at login post-zshrc.
#
zsh_timing_function ${(%):-%N}

# Execute code that does not affect the current session in the background.
{
	# Compile the completion dump to increase startup speed.
	zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
	if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
		zcompile "$zcompdump"
	fi
} &!

local TIMING_TOC=$(date +%s%N)
TIMING_DIFF=$(((TIMING_TOC - TIMING_TIC)/1000000))
echo $TIMING_DIFF
