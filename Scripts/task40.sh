#!/bin/bash

[[ $# -eq 3 ]] || { echo "Invalid number of arguments!"; exit 1; }

FILE1="${1}"
FILE2="${2}"
DIR="${3}"

touch "${FILE2}"

[[ -f "${FILE1}" -a -f "${FILE2}" ]] || { echo "Invalid file name!"; exit 2; }
[[ -r "${FILE1}" -a -r "${FILE2}" ]] || { echo "Files not readable!"; exit 3; }
[[ -d "${DIR}" ]] || { echo "Invalid directory name!"; exit 4; }
[[ -r "${DIR}" ]] || { echo "Directory not readable!"; exit 5; }

while read FILE;do
	not_valid_lines=$(egrep -vc '^{ [A-Za-z;-]+ };$|^#|^$' "${FILE}")
	if [[ "${not_valid_lines}" -ne 0 ]];then
		echo "Error in $(basename ${FILE}):"
	    echo "Line $(egrep -n '^{ [A-Za-z;-]+ };$|^#|^$' ${FILE})"
	else
		cat "${FILE}" >> "${FILE2}"
		username=$(basename ${FILE})
		if egrep -qv "${username}" "${FILE1}" ;then
			echo "${username}:$(pwgen -s 16)" >> "${FILE1}"
			echo "${username} $(pwgen -s 16)"
		fi
	fi
done< <$(find "${DIR}" -type f -name "*.cfg")
