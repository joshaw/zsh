# Created:  Tue 15 Oct 2013
# Modified: Wed 17 Jun 2015
# Author:   Josh Wainwright
# Filename: prompt.zsh
#

prompt_setup() {
	# prompt turns red if the previous command didn't exit with 0
	# number of >'s indicates the number of embeded shells
	local THIS_SHLVL=$((SHLVL-ZSH_SHLVL_INIT))
	local shell_level=$(echo ${(l:$THIS_SHLVL::>:)})

	local NL=$'\n'
	local p_path="%F{cyan}%~%F{8}%f"
	local p_root="%(!.%F{red}!%f.)"
	local p_level="%(?.%F{green}.%F{red})$shell_level%f"
	PROMPT="${NL}${p_path}${NL}${p_root}${p_level} "

	RPROMPT='%@'
	SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_setup "$@"
