#!/bin/bash

[[ $# -eq 1 ]] || { echo "Invalid number of arguments!"; exit 1; }

if [[ -z "${1}" ]];then
	echo "Argument should be non-empty string!"
	exit 2
fi

stat=$(cat /proc/acpi/wakeup | egrep "${1}" | awk '{print $3}')
if [[ "${stat}" == "*enabled" ]];then
	"${1}" > /proc/acpi/wakeup
fi
