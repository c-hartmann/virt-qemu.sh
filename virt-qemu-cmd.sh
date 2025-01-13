#!/bin/bash
# virt-qemu.sh | virt-qemu-cmd.sh
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
type -p xsltproc 1>/dev/null 2>&1|| error_exit "xsltproc command not found" 1

# check stylesheet
stylesheet="$HOME/.config/${_me%.*}.xsl"
test -f "$stylesheet" || error_exit "stylesheet file not found: $stylesheet" 2

# command line paramter is either a vm name or libvirt xml config file
libvirt_config=""
# libvirt_user_config_dir="$HOME/.config/libvirt/qemu"
# libvirt_root_config_dir="/lib/var/libvirt/qemu" # wild guess
if [[ $# > 0 ]] ; then
	if [[ -f "$1" ]] ; then
		# run it on file
		libvirt_config="$1"
		# TODO shall we check existence of validator?
		# TODO add option to bypass validation: --no-validate | --no-check
		if virt-xml-validate "$libvirt_config" 'domain' ; then
			xsltproc "$stylesheet" "$libvirt_config"
		else
			error_exit "no valid libvirt xml config: $libvirt_config" 3
		fi
	else
		# find first matching domain even on substring of it
		domain=$(virsh list --all | grep -m 1 "$1" 2>/dev/null | awk '{print $2}')
		if [[ -n ${domain} ]] ; then
			virsh dumpxml "$domain" | xsltproc "$stylesheet" -
		else
			error_exit "no such file or no domain matching: $1" 3
		fi
	fi
else
	# assume stdin
	xsltproc "$stylesheet" -
fi

# final newline
echo
