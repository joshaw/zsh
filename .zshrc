
if [[ $TERM == "xterm" ]]; then
	export TERM=xterm-256color
fi

path+="${HOME}/Bin"
path+="${HOME}/Tools"

files=(\
	'prompt.zsh'\
	'completion.zsh'\
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
		source ~/.zsh/$file
	fi
done
wait

#	ts=$(date +%s%N)
#	tt=$((($(date +%s%N) - $ts)/1000000))
#	echo "$file : $tt"

zsh_timing_function ${(%):-%N}
