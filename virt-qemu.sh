#!/bin/bash
# virt-qemu.sh
# create a qemu command line from libvirt xml config

export LANG=C

_me=$(basename $0)

# this requires xsltproc
# xsltproc=$(type -p xsltproc)

function error_exit()
{
	echo $1; exit ${2:-1}
}

# check xsltproc
type -p xsltproc || error_exit "xsltproc command not found" 1
# test -x "$xsltproc" || error_exit "xsltproc command not found" 1

# check stylesheet
stylesheet="$HOME/.config/${_me%.*}.xsl"
test -f "$stylesheet" || error_exit "stylesheet file not found: $stylesheet" 2
echo using: "$stylesheet"
# exit

# command line paramter is either a vm name or libvirt xml config file
libvirt_config=""
libvirt_config_dir="$HOME/.config/libvirt/qemu"
if [[ $# > 0 ]]; then
	test -f "$1" && libvirt_config="$1"
	test -f "$libvirt_config_dir/$1" && libvirt_config="$libvirt_config_dir/$1"
	test -f "$libvirt_config_dir/$1.xml" && libvirt_config="$libvirt_config_dir/$1.xml"
else
	libvirt_config="-"
fi

# run it
xsltproc "$stylesheet" "$libvirt_config"

# final newline
echo
