#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

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

# Set the the list of directories that cd searches.
 cdpath=(
	$cdpath
	~/Documents/CompSci/
 )

# Set the list of directories that Zsh searches for programs.
path=(
	/usr/{bin,sbin}
	/bin
	/sbin
	/usr/local/{bin,sbin}
	~/Bin
	/home/josh/.gem/ruby/2.0.0/bin
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-i -M -R -w -z-4 -~'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
	export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
	export TMPDIR="/tmp/$USER"
	mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
	mkdir -p "$TMPPREFIX"
fi
