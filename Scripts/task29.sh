#!/bin/bash

[ $# -eq 0 ] || { echo "Invalid number of arguments. Usage: $0"; exit 1; }

if [[ $(whoami) != "root" ]];then
	echo "This script must be executed as root!"
	exit 1
fi

TOTAL_ROOT_RSS="$(ps -u "root" -o rss= | awk '{s+=$1}END{print s}')"

while read USER_UID _HOME; do

	[[ "${USER_UID}" -ne 0 ]] || continue
	
	[[ ! -d "${_HOME}" ]] || [[ "$(stat -c "%u" "${_HOME}")" != "${USER_UID}" ]] || [[ "$(stat -c "%A" "${_HOME}"| cut -c3)" != "w" ]] || continue

	echo "${USER_UID} ${_HOME}"

	TOTAL_USER_RSS="$(ps -u "${USER_UID}" -o rss= | awk '{s+=$1}END{print s}')"
	
	[[ -n "${TOTAL_USER_RSS}" ]] || TOTAL_USER_RSS=0
	
	if [ "${TOTAL_USER_RSS}" -gt "${TOTAL_ROOT_RSS}" ]; then
		killall -u "${USER_UID}" -m .
		sleep 2
		killall -u "${USER_UID}" -KILL -m .
	fi

done < <(cut -d':' -f3,6 /etc/passwd)
