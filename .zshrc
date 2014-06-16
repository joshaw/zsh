if [[ $TERM == "xterm" ]]; then
	export TERM=xterm-256color
fi

if (( $+commands[fortune] )); then
	fortune
fi

files=(\
	'prompt'\
	'completion'\
	'git'\
	'spectrum'\
	'terminal'\
	'environment'\
	'aliases'\
	'history'\
	'syntax-highlighting'\
	'keybindings'\
	)

for file in $files; do
	source ~/.zsh/$file.zsh
done
# source ~/.fzf.zsh
