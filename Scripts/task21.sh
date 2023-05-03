#!/bin/bash

[[ $# -eq 3 ]] || { 
echo "Invalid number of arguments!" 
exit 1
}

FILE_PATH="${1}"

[[ -f "${FILE_PATH}" ]] || { echo "File ${FILE_PATH}" does not exist; exit 2; }

[[ -r "${FILE_PATH}" ]] || { echo "File ${FILE_PATH}" is not readable; exit 3; }

[[ -w "${FILE_PATH}" ]] || { echo "File ${FILE_PATH}" is not writable; exit 4; }

KEY_1="${2}"
KEY_2="${3}"

[[ -n "${KEY_1}" -a -n "${KEY_2}" ]] || { echo "There is a key with zero length"; exit 5; }

VAL_1="$(egrep "${KEY_1}=" "${FILE_PATH}" | awk -F'=' '{print $1}')"
VAL_2="$(egrep "${KEY_2}=" "${FILE_PATH}" | awk -F'=' '{print $2}')"

[ -n "${VAL_2}" ] || exit 0

NEW_VAL=""

for WORD in ${VAL_2}; do
	if egrep -qv "${WORD}" <(echo "${VAL_1}"); then
		NEW_VAL+="${WORD} "
	fi
done

sed -i -E "s/${KEY_2}=${VAL_2}/${KEY_2}=${NEW_VAL}/" "${FILE_PATH}"
