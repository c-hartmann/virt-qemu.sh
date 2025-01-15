#!/bin/bash
# virt-qemu.sh | virt-qemu-cmd.sh
# create or run a qemu command line from libvirt xml domain config

export LANG=C

ME=$(basename $0)

ERROR_GENERAL=1
ERROR_USAGE=2
ERROR_VALIDATION=9
ERROR_INTERNAL=99
ERROR_CMD_NOT_FOUND=127

function error_exit()
{
	echo -e $1; exit ${2:-$ERROR_GENERAL}
}

function usage_exit()
{
	cat 1>&2 <<- EOU
		usage: $ME [ --help | --no-validate | --run ] <domain-name> | <libvirt-domain-config-file>
	EOU
	exit $ERROR_USAGE
}

# default behavior
do_validate=true
do_run=false

# run or create (with defaults) my config file
rc="${HOME}/.config/${ME%.*}.rc"
if [[ -f "$rc" ]]; then
	source $rc
else
	cat >> "$rc" <<- EOF
		do_validate=$do_validate
		do_run=$do_run
	EOF
fi

# evaluate command line options
VALID_ARGS=$(getopt -o hnrx --long exec,help,no-validate,run -- "$@")
if [[ $? != 0 ]]; then
    usage_exit;
fi
eval set -- "$VALID_ARGS"
while [ : ]; do
	case "$1" in
		-h | --help | -help )
			usage_exit
		;;
		-n | --no-validate | -no-validate )
			do_validate=false
			shift 1
		;;
		-r | --run | -run | -x | --exec | -exec )
			do_run=true
			shift 1
		;;
		-- )
			shift 1
			break
			;;
	esac
done
# single - can not be handled via getopt. remove from @ (reading from stdin is default if no other argument is given)
if [[ $1 == '-' ]]; then
	shift 1
fi

# check required xsltproc
type -p xsltproc 1>/dev/null 2>&1 \
	|| error_exit "xsltproc command not found" $ERROR_CMD_NOT_FOUND

# check stylesheet (note: sudo will change to root home)
stylesheet="${HOME}/.local/share/${ME%.*}.xsl"
test -f "$stylesheet" \
	|| error_exit "stylesheet file not found: $stylesheet" $ERROR_INTERNAL

# command line paramter is either a vm name or libvirt xml config file
libvirt_config=""
# libvirt_user_config_dir="$HOME/.config/libvirt/qemu"
# libvirt_root_config_dir="/lib/var/libvirt/qemu" # wild guess
if [[ $# > 0 ]] ; then
	if [[ -f "$1" ]] ; then
		# run it on file
		libvirt_config="$1"
		if $do_validate; then
			type -p virt-xml-validate 1>/dev/null 2>&1 \
				|| error_exit "virt-xml-validate command not found (try option --no-validate)" $ERROR_CMD_NOT_FOUND
			if virt-xml-validate "$libvirt_config" 'domain' ; then
				qemu_cmd=$(xsltproc "$stylesheet" "$libvirt_config")
			else
				error_exit "no valid libvirt xml config: $libvirt_config" $ERROR_VALIDATION
			fi
		fi
	else
		# find (first) matching domain even if we habe just a substring of it
		domain=$(virsh list --all | grep -m 1 "$1" 2>/dev/null | awk '{print $2}')
		if [[ -n ${domain} ]] ; then
			qemu_cmd=$(virsh dumpxml "$domain" | xsltproc "$stylesheet" -)
		else
			error_exit "no such file or no domain matching: $1" $ERROR_USAGE
		fi
	fi
else
	# assume xml config given on stdin
	qemu_cmd=$(xsltproc "$stylesheet" -)
fi

# run or dump?
if $do_run; then
	exec $qemu_cmd
else
	echo $qemu_cmd
fi
