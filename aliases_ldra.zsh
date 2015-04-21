# Created:  Tue 20 Jan 2015
# Modified: Tue 21 Apr 2015
# Author:   Josh Wainwright
# Filename: aliases_ldra.zsh

function ldra-{{start,stop}_licenseserver,re-read_licensefile}() {
	name=$0
	cmd=${name#ldra-}
	cd -q ~/LDRA_flexlm/
	echo $cmd
	./${cmd}.sh
	cd -q -
}

alias ldralauncher='~/ldra/launcher/ldralauncher'

function ldra-{testbed,tbvision,tbmanager,tbrun}-{Ada,C_C++}-{946,950}() {
	name=$0
	p=(${(s/-/)name})
	cp ~/.ldra/Testbed.ini.$p[3]$p[4] ~/.ldra/Testbed.ini
	~/LDRA_Toolsuite/$p[4]/$p[3]/$p[2]
}

function cidr() {
	ipcalc -bn $1 | grep -E "Network|HostMin|HostMax"
}
