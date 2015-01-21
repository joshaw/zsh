# Created:  Tue 15 Oct 2013
# Modified: Wed 21 Jan 2015
# Author:   Josh Wainwright
# Filename: prompt.zsh
#
# Loads prompt themes.
#

# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit

# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# fastest possible way to check if repo is dirty
git_dirty() {
	# check if we're in a git repo
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	# check if it's dirty
	command git diff --quiet --ignore-submodules HEAD &>/dev/null

	(($? == 1)) && echo '*'
}

# displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
	local stop=$(date +%s)
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
#	(($elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5})) && echo ${elapsed}s
	echo ${elapsed}s
}

p_preexec() {
	cmd_timestamp=$(date +%s)
}

p_precmd() {
	# git info
	vcs_info

	print -P "\n%F{cyan}%~%F{8}$vcs_info_msg_0_$(git_dirty) $p_username%f %F{yellow}$(cmd_exec_time)%f"

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}

prompt_setup() {
	prompt_opts=(cr subst percent)

	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	add-zsh-hook precmd p_precmd
	add-zsh-hook preexec p_preexec

	zstyle ':vcs_info:*' enable git svn
	zstyle ':vcs_info:git*' formats ' %b'
	zstyle ':vcs_info:git*' actionformats ' %b|%a'

	# show username@host if logged in through SSH
	[[ "$SSH_CONNECTION" != '' ]] && p_username='%n@%m '

	# prompt turns red if the previous command didn't exit with 0
	# number of >'s indicates the number of embeded shells
	local THIS_SHLVL=$((SHLVL-ZSH_SHLVL_INIT))
	shell_level=$(printf '>%.0s' $(seq 1 $THIS_SHLVL))
	PROMPT="%(?.%F{green}.%F{red})$shell_level%f "

	RPROMPT='%*'
	SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_setup "$@"
