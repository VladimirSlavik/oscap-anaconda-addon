#!/bin/bash

build_dir=$PWD

actions=(download_rpms install_rpms install_addon_from_repo create_image cleanup)


# ARG_POSITIONAL_SINGLE([start-with],[Action to start with - one of: ${actions[*]}],[install_rpms])
# ARG_OPTIONAL_BOOLEAN([languages],[l],[Include languages in the image. The increased image size may cause problems.])
# ARG_OPTIONAL_SINGLE([rpm-dir],[],[Where to put/take from RPMs to install],[$build_dir/rpm])
# ARG_OPTIONAL_SINGLE([tmp-root],[],[Fake temp root],[$(mktemp -d)])
# ARG_OPTIONAL_SINGLE([releasever],[r],[Version of the target OS],[28])
# ARG_TYPE_GROUP_SET([action],[ACTION],[start-with],[download_rpms,install_rpms,install_addon_from_repo,create_image,cleanup],[index])
# ARG_HELP([])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

# validators

action()
{
	local _allowed=("download_rpms" "install_rpms" "install_addon_from_repo" "create_image" "cleanup") _seeking="$1" _idx=0
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && { test "$3" = "idx" && echo "$_idx" || echo "$element"; } && return 0
		_idx=$((_idx + 1))
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'download_rpms', 'install_rpms', 'install_addon_from_repo', 'create_image' and 'cleanup'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='lrh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_start_with="install_rpms"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_languages="off"
_arg_rpm_dir="$build_dir/rpm"
_arg_tmp_root="$(mktemp -d)"
_arg_releasever="28"


print_help()
{
	printf 'Usage: %s [-l|--(no-)languages] [--rpm-dir <arg>] [--tmp-root <arg>] [-r|--releasever <arg>] [-h|--help] [<start-with>]\n' "$0"
	printf '\t%s\n' "<start-with>: Action to start with - one of: ${actions[*]}. Can be one of: 'download_rpms', 'install_rpms', 'install_addon_from_repo', 'create_image' and 'cleanup' (default: 'install_rpms')"
	printf '\t%s\n' "-l, --languages, --no-languages: Include languages in the image. The increased image size may cause problems. (off by default)"
	printf '\t%s\n' "--rpm-dir: Where to put/take from RPMs to install (default: '$build_dir/rpm')"
	printf '\t%s\n' "--tmp-root: Fake temp root (default: '$(mktemp -d)')"
	printf '\t%s\n' "-r, --releasever: Version of the target OS (default: '28')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-l|--no-languages|--languages)
				_arg_languages="on"
				test "${1:0:5}" = "--no-" && _arg_languages="off"
				;;
			-l*)
				_arg_languages="on"
				_next="${_key##-l}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-l" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			--rpm-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_rpm_dir="$2"
				shift
				;;
			--rpm-dir=*)
				_arg_rpm_dir="${_key##--rpm-dir=}"
				;;
			--tmp-root)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_tmp_root="$2"
				shift
				;;
			--tmp-root=*)
				_arg_tmp_root="${_key##--tmp-root=}"
				;;
			-r|--releasever)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_releasever="$2"
				shift
				;;
			--releasever=*)
				_arg_releasever="${_key##--releasever=}"
				;;
			-r*)
				_arg_releasever="${_key##-r}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 1, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_start_with "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash
# Validation of values
_arg_start_with="$(action "$_arg_start_with" "start-with")" || exit 1
_arg_start_with_index="$(action "$_arg_start_with" "start-with" idx)"

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

tmp_root="$_arg_tmp_root"
rpmdir="$_arg_rpm_dir"


packages="
	openscap
	openscap-python3
	openscap-scanner
	python3-cpio
	python3-pycurl
	xmlsec1-openssl
	oscap-anaconda-addon
	xmlsec1
	xmlsec1-openssl
"


download_rpms() {
	mkdir -p "$rpmdir"
	(cd "$rpmdir" && dnf download --arch x86_64,noarch --releasever "$_arg_releasever" $packages) || die "Failed to download RPMs for Fedora $_arg_releasever"
}


install_rpms() {
	test -d "$rpmdir" || return 0  # Nothing to do, no RPM dir exists
	# Install pre-downloaded RPMs to the fake root, sudo is required
	for pkg in "$rpmdir/"*.rpm; do
		sudo rpm -i --nodeps --root "$tmp_root" "$pkg" || die "Failed to install dependency $pkg to $tmp_root, which is needed for the installer to be fully operational."
	done
}


install_addon_from_repo() {
	local install_po_files
	if test "$_arg_languages" = off; then
		install_po_files="DEFAULT_INSTALL_OF_PO_FILES=no"
	else
		install_po_files="DEFAULT_INSTALL_OF_PO_FILES=yes"
	fi
	# "copy files" to new root, sudo may be needed because we may overwrite files installed by rpm
	$SUDO make install "$install_po_files" DESTDIR="${tmp_root}" >&2 || die "Failed to install the addon to $tmp_root."
}


create_image() {
	# create update image
	(cd "$tmp_root" && find -L . | cpio -oc | gzip > "$build_dir/update.img") || die "Failed to create the update image from the $tmp_root."
}


cleanup() {
	# cleanup, sudo may be needed because former RPM installs
	$SUDO rm -rf "$tmp_root"
}

if test $_arg_start_with_index -gt 1; then
	SUDO=
else
	SUDO=sudo
	$SUDO true || die "Unable to get sudo working, bailing out."
fi

for (( action_index=_arg_start_with_index;  action_index < ${#actions[*]}; action_index++ )) do
	"${actions[$action_index]}"
done

# ] <-- needed because of Argbash
