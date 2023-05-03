#!/bin/bash

[[ $# -eq 2 ]] || {echo "Invalid arguments number!"; exit 1;}

FILE="${1}"
DIR="${2}"

if [[ ! -d ${DIR} ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r ${DIR} ]];then
	echo "Directory is not readable!"
	exit 3
fi

if [[ -f ${FILE} ]];then
	echo "Invalid file name!"
	exit 4
elif [[ ! -r ${FILE} ]];then
	echo "File is not readable!"
	exit 5
fi

[[ "$(find "${DIR}" -mindepth 1 | wc -l)" -eq 0 ]] || { echo "Dir is not empty"; exit 6; }

CNT=1;

touch "${DIR}/dict.txt"

while read LINE;do
	NAME_FAMILY="$(cut -d':' -f1 < <(echo "${LINE}") | sed -E "s/\(.*\)//" | awk '$1=$1')"
		NUMBER="$(cat "${DIR}/dict.txt" | egrep "${NAME_FAMILY}" | cut -d';' -f2 )"

	if [ -z "$NUMBER" ]; then
		# number does not exist -> add to dict.txt
		echo "${NAME_FAMILY};${CNT}" >> "${DIR}/dict.txt"
		NUMBER="${CNT}"
		CNT=$( expr "${CNT}" + 1 )
	fi
	echo "${LINE}" | cut -d':' -f2 >> "${DIR}/${NUMBER}.txt"
done < "${FILE}"
