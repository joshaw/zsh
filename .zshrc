fortune

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
	)

for file in $files; do
	source ~/.zsh/$file.zsh
done
