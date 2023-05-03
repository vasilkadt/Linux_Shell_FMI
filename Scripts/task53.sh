#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1 }

DIR="${1}"
NUM="${2}"

if [[ ! -d "${DIR}" ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r "${DIR}" ]];then
	echo "Directory not readable!"
	exit 3
fi

function validate_num {
	egrep '[1-9][0-9]?' <(echo "${NUM}")
}

if [[ $(find "${DIR}" -mindepth 1 | wc -l) -eq 0 ]];then
	echo "Directory is empty!"
	exit 4
fi

function remove_backups {
	if [[ $(egrep -c "${2}" "${1}") -eq 0 ]];then
		return 0
	else
		used=$(df "${1}" | tail 1 | awk '{print 5}' | sed 's/%//')
		while read line;do
			if [[ ${used} -gt ${NUM} ]];then
			rm -r "${line}"
			fi
		done< <(egrep "${2}" "${1}/1")
		return 1
	fi
}

if validate_num;then
	for file in $(find "${DIR}/1" | sort -t'-' -r -k3);do
		used=$(df "${DIR}" | tail 1 | awk '{print 5}' | sed 's/%//')

		if [[ ${used} -le ${NUM} ]];then
			exit 0
		fi

		name=$(echo "${file}" | awk -F'-' '{print $1,$2}' | sed 's/ /-/')
		
		if remove_backups "${DIR}/0" "${name}"; then
			continue
		fi
		if remove_backups "${DIR}/1" "${name}";then
			continue
		fi
		if remove_backups "${DIR}/2" "${name}";then
			continue
		fi
		if remove_backups "${DIR}/3" "${name}";then
			continue
		fi
	done
else
	echo "Invalid num argument"
	exit 5
fi

for symlink in $(find -L "${DIR}" -type l);do
	rm "${symlink}"
done

