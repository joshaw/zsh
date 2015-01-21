# Created:  Tue 15 Oct 2013
# Modified: Wed 21 Jan 2015
# Author:   Josh Wainwright
# Filename: .zshrc

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

vman() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}
compdef vman="man"
