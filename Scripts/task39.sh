#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1; }

DIR1="${1}"
DIR2="${2}"

mkdir "${DIR2}"

if [[ ! -d "${DIR1}" ]];then 
	echo "Invalid directory name!"
	exit 2
elif [[ ! -d "${DIR2}" ]];then
	echo "Invalid directory name!"
	exit 3
elif [[ ! -r "${DIR1}" ]];then
	echo "Directory not readable!"
	exit 4
elif [[ ! -r "${DIR2}" ]];then
	echo "Directory is not readable!"
	exit 5
fi

while read FILE;do
	file_name=$(echo "${FILE}" | awk -F'/' '{print $NF}' | tr -s ' ' | sed 's/^[ ]//' | sed 's/[ ]$//')
	title=$(echo "${file_name}" | cut -d'.' -f1 | sed 's/([^)]*)//g')
	album="misc"
	if [[ $(echo "${file_name}" | cut -d'.' -f1 | egrep -c '\(') -ge 1 ]];then
		album=$(echo "${file_name}" | cut -d'.' -f1 | awk -F'(' '{print $NF}' | awk -F')' '{print $1}')
	fi
	data=$(stat -c "%y" "${FILE}" | cut -d' ' -f1)
	hesh=$(sha256sum "${FILE}" | cut -c-16)

	cp "${FILE}" "${DIR1}/images/${hesh}.jpg"
	ln -s "${DIR1}/by-date/${data}/by-album/${album}/by-tytle/${title}.jpg"  "${DIR1}/images/${hesh}.jpg"
	ln -s "${DIR1}/by-date/${data}/by-tytle/${title}.jpg"  "${DIR1}/images/${hesh}.jpg"
	ln -s "${DIR1}/by-album/${album}/by-date/${data}/by-tytle/${title}.jpg"  "${DIR1}/images/${hesh}.jpg"
	ln -s "${DIR1}/by-album/${album}/by-tytle/${title}.jpg"  "${DIR1}/images/${hesh}.jpg"
	ln -s "${DIR1}/by-tytle/${title}.jpg"  "${DIR1}/images/${hesh}.jpg"
done< <(find "${DIR1}" -type f -name "*.jpg")
