#!/bin/bash

[[ $# -ne 0 ]] || { echo "Invalid number of arguments!"; exit 1; }

function validateSOA {
	cat "${1}" | head -n 1 | egrep '[a-z]([a-z.])+. ([0-9]+)? IN SOA ([a-z][a-z.]+ ){1,}'
}

for arg in "$@";do

	if [[ ! -f "${arg}" ]];then
		echo "${arg} is invalid file name!"
		exit 2
	elif [[ ! -r "${arg}" ]];then
		echo "${arg} is not readable!"
		exit 3
	fi

    serial=""
if validateSOA "${arg}";then
	if [[ $(cat "${arg}" | head 1 | egrep -qc '(') -eq 0 ]];then
		is_second_num=$(cat "${arg}" | head 1 | tr -s ' ' | cut -d' ' -f2)
		if cat ${is_second_num} | egrep -q '^[0-9]+$' ;then
			serial=$(cat "${arg}" | head 1 | tr -s ' ' | cut -d' ' -f7)
		else 
			serial=$(cat "${arg}" | head 1 | tr -s ' ' | cut -d' ' -f6)
		fi
	else 
		serial=$(cat "${arg}" | head 2 | tr -s ' ' | cut -d; -f1 | sed 's/ //g')
	fi

	if [[ ${serial} -lt $(date) ]];then
		sed "s/${serial}/$(date)00/g" "${arg}"
	elif [[ ${serial} -eq $(date) ]];then
		new_serial=$(echo "${serial} + 1" | bc)
		sed "s/${serial}/${new_serial}/g" "${arg}"
	fi
else
	echo "Invalid SOA file"
	exit 4
fi
done

