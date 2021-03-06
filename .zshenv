# Created:  Tue 15 Oct 2013
# Modified: Wed 21 Jan 2015
# Author:   Josh Wainwright
# Filename: .zshenv

#
# Browser
#
export BROWSER='open'

#
# Editors
#
export EDITOR='vim'
export VISUAL='gvim'
export PAGER='less'

#
# Language
#
if [[ -z "$LANG" ]]; then
	export LANG='en_GB.UTF-8'
fi

#
# Paths
#
typeset -gU cdpath fpath mailpath path

export CLASSPATH=.:/usr/share/java/junit.jar:/usr/share/imagej/ij.jar:${HOME}/Bin/ImageJ/ij.jar
# export CLASSPATH="$CLASSPATH:/home/students/jaw097/Bin/ImageJ/ij.jar:/usr/share/java/junit4.jar"

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-i -M -R -w -z-4 -~ -X -F'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
	export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
	export TMPDIR="/tmp/$USER"
	/usr/bin/mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
	/usr/bin/mkdir -p "$TMPPREFIX"
fi
