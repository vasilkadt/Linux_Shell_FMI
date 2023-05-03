#!/bin/bash

num=""

if [[ $# -eq 2 ]]; then
	num="${2}"
elif [[ $# -gt 2 ]]; then
	echo "Invalid number of arguments!"
	exit 1
elif [[ $# -eq 0 ]]; then
	echo "Invalid number of arguments!"
	exit 2
fi

dir="${1}"

if [[ ! -d "${dir}" ]]; then
	echo "Not a valid directory name!"
	exit 3
elif [[ ! -r "${dir}" ]]; then
	echo "Directory is not readable!"
	exit 4
fi

function validate_num {
	egrep -q '^[0-9]+$' <(echo "${1}")
}

function count_hardlinks {
	find "${1}" -samefile "${2}" 2>/dev/null | wc -l
}

function is_broken_symlink {
	file "${1}" | grep -q 'broken'
}

if [[ -n "${num}" ]]; then
	if validate_num "${num}" ; then

		while read f; do
			if [[ $(count_hardlinks "${dir}" "${f}") -ge "${num}" ]]; then
				echo "${f}"
			fi
		done < <(find "${dir}" -type f ! -name '.*' 2>/dev/null)
	else
		echo "Invalid number argument!"
		exit 5
	fi
else
	while read l; do
		if is_broken_symlink "${l}"; then
			echo "${l}"
		fi
	done < <(find "${dir}" -type l 2>/dev/null)
fi
s0600024@astero:~$ cat zad25.sh
[[ $# -eq 3 ]] || { echo "Usage: $0 <dirname> <dirname> <string>"; exit 1; }

src="${1}"
dst="${2}"
str="${3}"

[[ -d "${src}" ]] || { echo "Source is not a directory!"; exit 2; }
[[ -d "${dst}" ]] || { echo "Destination is not a directory!"; exit 3; }
[[ -r "${src}" -a -w "${src}" ]] || { echo "Source does not have \"r\" or \"w\" perm!"; exit 4; }
[[ -r "${dst}" -a -w "${dst}" ]] || { echo "Destination does not have \"r\" or \"w\" perm!"; exit 5; }

[[ $(id -u) -eq 0 ]] || { echo "Script not run as root (do nothing)!"; exit 0; }

dst_content=$( find "${dst}" -type f ! -name ".*" 2>/dev/null | wc -l)
[[ "${dst_content}" -eq 0 ]] || { echo "Destinarion dir must not have other files!"; exit 6; }

dir_name="$(dirname "${0}")"
while read file; do
   real_dir_base_name="$(echo "${file}" | sed -E "s/${src}\///")"

   mkdir -p "${dst}/$(dirname "${real_dir_base_name}")"
   mv "${file}" "${dst}/${real_dir_base_name}"
done < <(find "${src}" -type f -name "*${str}*" 2>/dev/null)
