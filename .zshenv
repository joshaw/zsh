#
# Defines environment variables.
#
dateloc=$(which date)
mkdirloc=$(which mkdir)
export ZSH_TIMING_TIC=$(eval $dateloc +%s%N)
local ZSH_TIMING_TEMP1=$ZSH_TIMING_TIC
function zsh_timing_function() {
	local ZSH_TIMING_TEMP2=$(eval $dateloc +%s%N)
	local ZSH_TIMING_DIFF=$(((ZSH_TIMING_TEMP2 - ZSH_TIMING_TEMP1) / 1000000 ))
	local file=$1
	echo -n "Sourced $file"
	echo " : $ZSH_TIMING_DIFF"
	export ZSH_TIMING_TEMP1=$(eval $dateloc +%s%N)
}

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
	eval $mkdirloc -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
	eval $mkdirloc -p "$TMPPREFIX"
fi

zsh_timing_function ${(%):-%N}
