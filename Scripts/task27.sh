#!/bin/bash

if [[ $# -eq 0 ]] || [[ $# -gt 2 ]]; then
	echo "Invalid number of arguments!"
	exit 1
fi

dir="${1}"
file=""

if [[ $# -eq 2 ]]; then
	file="${2}"
	if [[ ! -f "${file}" ]]; then
		echo "Invalid file!"
		exit 2
	elif [[ ! -w "${file}" ]]; then
		echo "File is not writable!"
		exit 3
	fi
fi

if [[ ! -d "${dir}" ]]; then
	echo "Invalid directory!"
	exit 4;
elif [[ ! -r "${dir}" ]]; then
	echo "Directory is not readable!"
	exit 5;
fi

cnt=0

while read symlink; do
	if egrep -q "broken" <(echo "${symlink}"); then
		cnt=$(expr $cnt '+' 1)
	else
		if [[ -n "${file}" ]]; then
			stat -c "%N" "$(echo "${symlink}" | cut -d':' -f1)" | tr -d "\)" >> "${file}"
		else
			stat -c "%N" "$(echo "${symlink}" | cut -d':' -f1)" | tr -d "\)"
		fi
	fi
done < <(find "${dir}" -type l 2>/dev/null -exec file {} \;)

if [[ -n "${file}" ]]; then
	cat "${file}"
fi

echo "Broken symlinks: ${cnt}"
