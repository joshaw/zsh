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

zsh_timing_function ${(%):-%N}

local ZSH_TIMING_TOC=$(date +%s%N)
local ZSH_TIMING_DIFF=$(((ZSH_TIMING_TOC - ZSH_TIMING_TIC)/1000000))
echo $ZSH_TIMING_DIFF
