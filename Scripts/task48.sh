#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1; }

DIR1="${1}"
DIR2="${2}"

if [[ ! -d "${DIR1}" ]]; then
	echo "Invalid directory!"
    exit 2
elif [[ ! -r "${DIR1}" ]]; then
   echo "Directory is not readable!"
   exit 3
fi

if [[ ! -d "${DIR2}" ]]; then
    echo "Invalid directory!"
    exit 4
elif [[ ! -w "${DIR2}" ]];then
	echo "Directory is not writable!"
	exit 5
fi

if [[ $(find "${DIR2}" -mindepth 1 | wc -l) -eq 0 ]];then
	echo "Directory ${DIR2} must be empty!"
	exit 6
fi

while read FILE;do
	new_file=$(echo "${FILE}" | sed "s/${DIR1}/${DIR2}/g")
	cp "${FILE}" "${new_file}"
done< <(find "${DIR1}" -type f ! -regex '^\.[.]*\.swp$')
