# Created:  Tue 15 Oct 2013
# Modified: Sat 25 Apr 2015
# Author:   Josh Wainwright
# Filename: prompt.zsh
#

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
	echo -n "$( git rev-parse --abbrev-ref HEAD) " &!
	echo -n "$( git rev-parse --short HEAD) " &!
	# check if it's dirty
	command test -n "$(git status --porcelain --ignore-submodules -unormal)"

	(($? == 0)) && echo '*'
}

# string length ignoring ansi escapes
strlen() {
	echo $((${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}} - 2))
}

p_precmd() {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	local p_preprompt="\n%F{cyan}%~%F{8} $p_username%f"
	print -P $p_preprompt

	# check async if there is anything to pull
	{
		# check if we're in a git repo
		[[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] &&
		# make sure working tree is not $HOME
		[[ "$(git rev-parse --show-toplevel)" != "$HOME" ]] &&
		# check the repo has not just been init'ed
		git rev-list -n 1 --all &> /dev/null &&
		{
			local arrows=''
			local arrnum=$(git rev-list --left-only --count HEAD...@'{u}' 2> /dev/null || echo 0)
			(( $arrnum > 0 )) && arrows+="^$arrnum"
			print -Pn "\e7\e[A\e[1G\e[`strlen $p_preprompt`C%F{8}$(git_dirty)%F{cyan}${arrows}%f\e8"
		}
	} &!
}

prompt_setup() {
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
