# Created:  Tue 15 Oct 2013
# Modified: Wed 21 Jan 2015
# Author:   Josh Wainwright
# Filename: terminal.zsh
#
# Sets terminal window and tab titles.
#

# Stop the system beep
xset -b 2> /dev/null &|

# Return if requirements are not found.
if [[ "$TERM" == 'dumb' ]]; then
	return 1
fi

# if [[ "$TERM" = "xterm-256color" ]] || [[ "$TERM" = "linux" ]]; then
# 	echo -ne '\e]10;#f1ebeb\a'  # foreground
# 	echo -ne '\e]11;#272822\a'  # background
# 	echo -ne '\e]12;#f1ebeb\a'  # cursor
# 	echo -ne '\e]P048483e'
# 	echo -ne '\e]P1dc2566'
# 	echo -ne '\e]P28fc029'
# 	echo -ne '\e]P3d4c96e'
# 	echo -ne '\e]P455bcce'
# 	echo -ne '\e]P59358fe'
# 	echo -ne '\e]P656b7a5'
# 	echo -ne '\e]P7acada1'
# 	echo -ne '\e]P876715e'
# 	echo -ne '\e]P9fa2772'
# 	echo -ne '\e]PAa7e22e'
# 	echo -ne '\e]PBe7db75'
# 	echo -ne '\e]PC66d9ee'
# 	echo -ne '\e]PDae82ff'
# 	echo -ne '\e]PE66efd5'
# 	echo -ne '\e]PFcfd0c2'
# fi
if [[ "$TERM" = "linux" ]]; then
	echo -en "\e]P0272822" #black
	echo -en "\e]P8F2F2F2" #darkgrey
	echo -en "\e]P1dc322f" #darkred
	echo -en "\e]P9ff3a36" #red
	echo -en "\e]P2a6e22e" #darkgreen
	echo -en "\e]PAc6f666" #green
	echo -en "\e]P3aa5500" #darkyellow
	echo -en "\e]PBffff55" #yellow
	echo -en "\e]P41e6fa8" #darkblue
	echo -en "\e]PC77a6d9" #blue
	echo -en "\e]PDeb2657" #magenta
	echo -en "\e]P5e86988" #darkmagenta
	echo -en "\e]PE66d9ef" #cyan
	echo -en "\e]P69cd9e5" #dark cyan
	echo -en "\e]P7aaaaaa" #lightgrey
	echo -en "\e]PFf8f8f2" #white
	# clear
fi

# # Sets the tab and window titles with a given command.
# function set-titles-with-command {
# 	emulate -L zsh
# 	setopt EXTENDED_GLOB

# 	# Get the command name that is under job control.
# 	if [[ "${1[(w)1]}" == (fg|%*)(\;|) ]]; then
# 		# Get the job name, and, if missing, set it to the default %+.
# 		local job_name="${${1[(wr)%*(\;|)]}:-%+}"

# 		# Make a local copy for use in the subshell.
# 		local -A jobtexts_from_parent_shell
# 		jobtexts_from_parent_shell=(${(kv)jobtexts})

# 		jobs $job_name 2>/dev/null > >(
# 			read index discarded
# 			# The index is already surrounded by brackets: [1].
# 			set-titles-with-command "${(e):-\$jobtexts_from_parent_shell$index}"
# 		)
# 	else
# 		# Set the command name, or in the case of sudo or ssh, the next command.
# 		local cmd=${${1[(wr)^(*=*|sudo|ssh|-*)]}:t}
# 		local truncated_cmd="${cmd/(#m)?(#c15,)/${MATCH[1,12]}...}"
# 		unset MATCH

# 		if [[ "$TERM" == screen* ]]; then
# 			# set-screen-window-title "$truncated_cmd"
# 		else
# 			set-terminal-window-title "$cmd"
# 			set-terminal-tab-title "$truncated_cmd"
# 		fi
# 	fi
# }

# # Sets the tab and window titles with a given path.
# function set-titles-with-path {
# 	emulate -L zsh
# 	setopt EXTENDED_GLOB

# 	local absolute_path="${${1:a}:-$PWD}"

# 	if [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
# 		printf '\e]7;%s\a' "file://$HOST${absolute_path// /%20}"
# 	else
# 		local abbreviated_path="${absolute_path/#$HOME/~}"
# 		local truncated_path="${abbreviated_path/(#m)?(#c15,)/...${MATCH[-12,-1]}}"
# 		unset MATCH

# 		if [[ "$TERM" == screen* ]]; then
# 			set-screen-window-title "$truncated_path"
# 		else
# 			set-terminal-window-title "$abbreviated_path"
# 			set-terminal-tab-title "$truncated_path"
# 		fi
# 	fi
# }

# # Don't override precmd/preexec; append to hook array.
# autoload -U is-at-least
# if is-at-least 5.0.0; then
# 	autoload -Uz add-zsh-hook

# 	# Sets the tab and window titles before the prompt is displayed.
# 	function set-titles-precmd {
# 		set-titles-with-path
# 	}
# 	add-zsh-hook precmd set-titles-precmd

# 	# Sets the tab and window titles before command execution.
# 	function set-titles-preexec {
# 		set-titles-with-command "$2"
# 	}
# 	add-zsh-hook preexec set-titles-preexec
# fi
