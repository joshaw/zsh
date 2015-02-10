# Created:  Tue 15 Oct 2013
# Modified: Mon 09 Feb 2015
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
	[[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return
	echo -n " $(git rev-parse --abbrev-ref HEAD) "
	# check if it's dirty
	command test -n "$(git status --porcelain --ignore-submodules -unormal)"

	(($? == 0)) && echo '*'
}

# string length ignoring ansi escapes
string_length() {
	echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

p_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	local p_preprompt="\n%F{cyan}%~%F{8} $p_username%f"
	print -P $p_preprompt

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp

	# check async if there is anything to pull
	{
		# check if we're in a git repo
		[[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] &&
		# make sure working tree is not $HOME
		[[ "$(command git rev-parse --show-toplevel)" != "$HOME" ]] &&
		# check check if there is anything to pull
		command git fetch &>/dev/null &&
		# check if there is an upstream configured for this branch
		command git rev-parse --abbrev-ref @'{u}' &>/dev/null && {
			local arrows=''
			(( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows='v'
			(( $(command git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) && arrows+='^'
			print -Pn "\e7\e[A\e[1G\e[`string_length $p_preprompt`C%F{8}$(git_dirty)%f%F{cyan}${arrows}%f\e8"
		}
	} &!
}

prompt_setup() {
	prompt_opts=(cr subst percent)

	autoload -Uz add-zsh-hook

	add-zsh-hook precmd p_precmd

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
