#!/bin/bash

[[ $# -eq 1 ]] || { echo "Invalid number of arguments!"; exit 1; }

FILE="${1}"

if [[ ! -f "${FILE}" ]];then
	echo "Invalid file name!"
	echo 2
elif [[ ! -r "${FILE}" ]];then
	echo "File is not readable!"
	exit 3
fi

while read LINE;do
	device=$(echo ${LINE} | awk '{print $1}')
	if [[ ${device} != "#" ]];then
		state=$(echo ${LINE} | awk 'print $2')
		if egrep "${device}" "/proc/acpi/wakeup" ;then
			state2=$(egrep "${device}" "/proc/acpi/wakeup" | awk '{print $2}')
			if [[ "${state}" != "${state2}" ]];then
				echo ${device} > "/proc/acpi/wakeup"
			fi
		else
			echo "${device} not exists!"
			continue
		fi
	fi
done< <"${FILE}"
