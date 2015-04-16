# Created:  Tue 15 Oct 2013
# Modified: Thu 16 Apr 2015
# Author:   Josh Wainwright
# Filename: .zshrc

if [[ $TERM == "xterm" ]]; then
	export TERM=xterm-256color
fi

path+="${HOME}/Bin"
path+="${HOME}/Tools"

files=(\
	'prompt.zsh'\
	'git.zsh'\
	'spectrum.zsh'\
	'environment.zsh'\
	'aliases.zsh'\
	'history.zsh'\
	'terminal.zsh'\
	'syntax-highlighting.zsh'\
	'keybindings.zsh'\
	)

for file in $files; do
	if [[ -f ~/.zsh/$file ]]; then
		# ts=$(date +%s%N)
		source ~/.zsh/$file
		# tt=$((($(date +%s%N) - $ts)/1000000))
		# echo "$file : $tt"
	fi
done


if (( $+commands[remind] )) ; then
	if [ $SHLVL -eq 1 ]; then
		command remind ~/.remind/reminders.rem
	fi
fi

vman() {
	vim -c "SuperMan $*"

	if [ "$?" != "0" ]; then
		echo "No manual entry for $*"
	fi
	compdef vman="man"
}
