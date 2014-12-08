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

# Editor
alias e='vim'
alias ee='gvim'
alias vimrc='vim -c ":e \$MYVIMRC"'

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

if (( $+commands[vcp] )); then
	alias cp='vcp -tv'
fi

if ! hash clear 2> /dev/null; then
	alias clear='printf "\033c"'
fi

alias bat="upower -d | grep -E --color=none 'state|percentage' | sed 's/ \+/ /g' | column -s: -t"
alias imagej="cd -q ~/Bin/ImageJ/ && ./run; cd -q -"

alias chromeos="sudo cgpt add -i 6 -P 0 -S 0 /dev/mmcblk0"

function chpwd() {
	emulate -L zsh
	ls -lh
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

alias suspend='sudo systemctl suspend'
# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

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

# Media -------------------------------
alias mpv='mpv --save-position-on-quit'
alias mpa='mpv --no-video'
alias mplayer='mplayer -msgcolor -nolirc -nojoystick'
alias mute-beep='xset -b && sudo rmmod pcspkr'
alias play-dvd='mplayer -nocache -dvd-device /dev/sr0 -mouse-movements dvdnav://'

alias vimp='vim ~/.config/.info.gpg'

# }}}
# Functions {{{

# mcd {{{
# Makes a directory and changes to it.
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}
# }}}

# slit {{{
# Prints columns 1 2 3 ... n.
function slit {
	awk "{ print ${(j:,:):-\$${^@}} }"
}
# }}}

# find-exec {{{
# Finds files and executes a command on them.
function find-exec {
	find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}
# }}}

# Search through multiple pdf files for string
# function pdfgrep {
# 	# find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | egrep --ignore-case --with-filename --label="{}" --color '"$1" \;
# 	find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "$1"' \;
# }

# paclist {{{
paclist() {
	sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}
# }}}

# shebang {{{
# Create a new script, make executable and add shebang
shebang() {
	if i=$(which $1); then
		printf '#!%s\n\n' $i >  $2 && vim + $2 && chmod 755 $2;
	else
		echo "'which' could not find $1, is it in your \$PATH?";
	fi;
}
# }}}

# svg2pdf {{{
# Convert svg to pdf
function svg2pdf (){
	rsvg-convert -f pdf $1 >! $1:r.pdf
}
# }}}

# pocket {{{
# Send link to pocket
function pocket() {
	for ARG in "$@"; do
		echo $ARG | /usr/bin/mutt -s link add@getpocket.com
	done
}
# }}}

# google {{{
# Open google search in web browser
function google () {
	st="$@"
	open -fw "http://www.google.com/search?q=${st}"
}
# }}}

# enc/dec {{{
# Encrypt and decrypt folders using tar and openssl
function enc () {
	tar --create --file - --posix --gzip -- $1 | openssl enc -e -aes256 -out $1.enc
}

function dec () {
	openssl enc -d -aes256 -in $1 | tar --extract --file - --gzip
}
# }}}

# Backwards change directory {{{
bd () {
  (($#<1)) && {
    print -- "usage: $0 <name-of-any-parent-directory>"
    return 1
  } >&2
  # Get parents (in reverse order)
  local parents
  local num_tmp="${PWD//[^\/]}"
  local num=${#num_tmp}
  local i
  for i in {$((num+1))..2}
  do
    parents=($parents "`echo $PWD | cut -d'/' -f$i`")
  done
  parents=($parents "/")
  # Build dest and 'cd' to it
  local dest="./"
  local parent
  foreach parent (${parents})
  do
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
    dest+="../"
  done
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}
_bd () {
  # Get parents (in reverse order)
  local num_tmp="${PWD//[^\/]}"
  local num=${#num_tmp}
  local i
  for i in {$((num+1))..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}
compctl -V directories -K _bd bd
# }}}

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
# Ranger Automatic cd {{{
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile='/tmp/chosendir'
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile" > /dev/null
}
# }}}

# vim: fdm=marker
