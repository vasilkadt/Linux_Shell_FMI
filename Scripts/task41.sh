#!/bin/bash

FILE="${1}"
KEY="${2}"
VALUE="${3}"

[[ $# -eq 3 ]] || { echo "Invalid number of arguments!"; exit 1; }

if [[ ! -f "${FILE}" ]];then
	echo "Invalid file name!"
	exit 2
elif [[ ! -r "${FILE}" ]];then
	echo "File not readable!"
	exit 3
fi

if [[ -z "${KEY}" ]];then
	echo "Invalid key argument!"
	exit 4
elif [[ -z "${VALUE}" ]];then
	echo "Invalid value argument!"
	exit 5
fi

if egrep -q "[ \t]*${KEY}[ \t]*=" "${FILE}" ;then
	oldkey_part1="$(egrep "[ \t]*${KEY}[ \t]*=" "${FILE}" | cut -d'=' -f1)"
	oldkey_part2="$(egrep "[ \t]*${KEY}[ \t]*=" "${FILE}" | cut -d'=' -f2)"
	sed "s/${oldkey_part1}=${oldkey_part2}/# ${oldkey_part1}=${oldkey_part2} # edited at $(date) by $(whoami)\n${KEY} = ${VALUE} # added at $(date) by $(whoami)/g" "${FILE}"
else
	echo "${KEY} = ${VALUE} # added at $(date) by $(whoami)" >> "${FILE}"
fi
