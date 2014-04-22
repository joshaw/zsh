#
# Defines general aliases and functions.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Suraj N. Kurapati <sunaku@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Correct commands.
setopt CORRECT

# Aliases {{{

# Define general aliases.
alias _='sudo'
alias b='${(z)BROWSER}'
alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias p='${(z)PAGER}'
alias type='type -a'
alias x='exit'

alias ls='ls --color=always --group-directories-first' # Lists with colour enabled
alias l='ls -1A'           # Lists in one column, hidden files.
alias ll='ls -lh'          # Lists human readable sizes.
alias lr='ll -R'           # Lists human readable sizes, recursively.
alias la='ll -A'           # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"'   # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'          # Lists sorted by extension (GNU only).
alias lk='ll -Sr'          # Lists sorted by size, largest last.
alias lt='ll -tr'          # Lists sorted by date, most recent last.
alias lc='lt -c'           # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'           # Lists sorted by date, most recent last, shows access time.
alias sl='ls'              # I often screw this up.

function chpwd() {
	ll
}

# Directories
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# File Download
if (( $+commands[curl] )); then
	alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
	alias get='wget --continue --progress=bar --timestamping'
fi

# Resource Usage
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
	alias top=htop
else
	alias topc='top -o cpu'
	alias topm='top -o vsize'
fi

# Miscellaneous

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Serves a directory via HTTP.
alias http-serve='python -m SimpleHTTPServer'

alias reload!='. ~/.zshrc'

#alias ls='ls --color=auto'
alias mv='mv -i -v'
alias rm='rm -v'
alias less='less -F'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

# Rebuild dwm, install and restart -------
alias redwm='cd ~/.packages/dwm; makepkg -g >> PKGBUILD; makepkg -fi --noconfirm; killall dwm'

# Build instructions
alias g++='g++ -Wall -o'
alias junit='java org.junit.runner.JUnitCore'

# Pointess command to look wierd and cool
alias useless='while [ true ]; do head -n 100 /dev/urandom; sleep .1; done | hexdump -C | grep "ca fe"'

alias mutt='export WRAPMARGIN=$(( $COLUMNS - 80 )) && mutt'

# Media -------------------------------
alias mpv='mpv --save-position-on-quit'
alias mplayer='mplayer -msgcolor -nolirc -nojoystick'
alias mute-beep='xset -b && sudo rmmod pcspkr'
alias play-dvd='mplayer -nocache -dvd-device /dev/sr0 -mouse-movements dvdnav://'

# }}}
# Functions {{{

# Makes a directory and changes to it.
function mkdcd {
	[[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
	builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
	builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
	awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
	find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Search through multiple pdf files for string
# function pdfgrep {
# 	# find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | egrep --ignore-case --with-filename --label="{}" --color '"$1" \;
# 	find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "$1"' \;
# }

# Displays user owned processes status.
function psu {
	ps -U "${1:-$USER}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Pacman
paclist() {
	sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

# Create a new script, make executable and add shebang
shebang() {
	if i=$(which $1); then
		printf '#!%s\n\n' $i >  $2 && vim + $2 && chmod 755 $2;
	else
		echo "'which' could not find $1, is it in your \$PATH?";
	fi;
}

# Convert svg to pdf
function svg2pdf (){
	rsvg-convert -f pdf $1 >! $1:r.pdf
}

# }}}
# Zsh Bookmark movements {{{

ZSH_BOOKMARKS="$HOME/.zsh/cdbookmarks"

function cdb_edit() {
	$EDITOR "$ZSH_BOOKMARKS"
}

function cdb() {
	local entry
	index=0
	for entry in $(echo "$1" | tr '/' '\n'); do
		local CD
		CD=$(egrep "^$entry\\s" "$ZSH_BOOKMARKS" | sed "s#^$entry\\s\+##")
		if [ -z "$CD" ]; then
			echo "$0: no such bookmark: $entry"
			return 1
		else
			builtin cd "$CD"
		fi
	done
}

function _cdb() {
	reply=(`cat "$ZSH_BOOKMARKS" | sed -e 's#^\(.*\)\s.*$#\1#g'`)
}

compctl -K _cdb cdb
# }}}

# vim: fdm=marker
