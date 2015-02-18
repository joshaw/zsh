# Created:  Tue 15 Oct 2013
# Modified: Wed 18 Feb 2015
# Author:   Josh Wainwright
# Filename: aliases.zsh
#
# Defines general aliases and functions.
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
hash nvim 2> /dev/null && alias vim='nvim'
alias vimrc='vim -c ":e \$MYVIMRC"'

alias ls='ls --color=always --group-directories-first' # Lists with colour enabled
alias l='ls -1A'           # Lists in one column, hidden files.
alias ll='ls -lh'          # Lists human readable sizes.
alias lll='ls -Alh --sort=size . | tr -s " " | cut -d " " -f 5,9'
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

#alias vimp='vim ~/Documents/Details/pass.gpg'
function vimp {
	local search=$1
	local file="~/Documents/Details/pass.gpg"
	if [ -z $search ]; then
		vim $file -c "normal gg"
	else
		vim $file -c "/\c^$search"
	fi
}

# }}}
# Functions {{{

# exists {{{
function exists() {
	hash "$1" 2>&1 > /dev/null
	return $?
}
# }}}

# mcd {{{
# Makes a directory and changes to it.
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}
# }}}

# find-exec {{{
# Finds files and executes a command on them.
function find-exec {
	find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}
# }}}

# newest {{{
# show newest files
# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
function newest () {
	find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | grep -v cache | grep -v ".git" | sort -r | less
}
# }}}

# pdfgrep {{{
# Search through multiple pdf files for string
function pdfgrep {
	if exists pdfgrep; then
		pdfgrep "$@"
		exit $?
	fi
	if ! exists pdftotext; then
		pdftotext=/cygdrive/c/progs/Git/bin/pdftotext.exe
	else
		pdftotext=$(which pdftotext)
	fi
	find . -name '*.pdf' -exec sh -c "$pdftotext \"{}\" - | grep -i --with-filename --label=\"{}\" --color \"$1\"" \;
}
# }}}

# paclist {{{
function paclist() {
	sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
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

# Backwards change directory {{{
function bd () {
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

# bakuf {{{
function bakuf () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y-%m-%d);
    	firstpart=${oldname%.*}
        ext=${oldname##*.}
        newname=$firstpart.$datepart.$ext
        cp -R ${oldname} ${newname};
    fi
}
# }}}

# pwgen {{{
function pwgen() {
	< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-16};echo;
}
# }}}

# cdf {{{
function cdf() {
	if exists dmenu; then
		local dmenu="dmenu -i -b -l 20"
	elif exists slmenu; then
		local dmenu="slmenu -i -b -l 20"
	else
		exit
	fi

	if [[ -e ~/.files ]]; then
		local cd_file="$(eval $dmenu < ~/.files)"
	elif exists lsall; then
		local cd_file="$(lsall | eval $dmenu)"
	fi
	if [[ ! -z $cd_file ]]; then
		local cd_path="$(dirname $cd_file)"
		cd_path=${cd_path// /\\ }
		eval "cd $cd_path"
	fi
}
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

. ~/.zsh/aliases_ldra.zsh

# vim: fdm=marker
