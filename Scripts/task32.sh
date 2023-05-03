#!/bin/bash

[[ $# -eq 2 ]] || {echo "Invalid number of arguments!"; exit 1; }

a="${1}"
b="${2}"

if [[ ! -f "${a}" ]] ;then
    echo "Invalid file"
    exit 2
elif [[ ! -r "${a}" ]]; then
	echo "File not readable"
	exit 3;
fi

if [[ ! -f "${b}" ]];then
	echo "Invalid file!"
	exit 4
elif [[ ! -w "${b}" ]];then
	echo "File not writable!"
	exit 5
fi

while read LINE; do
    CUTLINE="$( echo "$LINE" | cut -d',' -f2- )"
    if egrep -q ",${CUTLINE}$" "${b}" ; then
        continue;
    else
        echo "${LINE}" >> "${b}"
    fi

done < <( cat "${a}" | sort -t',' -nk1)
