#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1; }

FILE="${1}"
DIR="${2}"

if [[ ! -d "${DIR}" ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r "${DIR}" ]];then
	echo "Directory not readable!"
	exit 3
fi

touch "${FILE}"

if [[ ! -f "${FILE}" ]];then
	echo "Invalid file name!"
	exit 4
elif [[ ! -r "${FILE}" ]];then
	echo "File not readable!"
	exit 5
fi

[[ $(find "${DIR}" -mindepth 1 | wc -l) -ne 0 ]] || { echo "Directory is empty!"; exit 6; }

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" > "${FILE}"

while read LINE;do
	host_name=$(basename "${LINE}")
	args="$(cat "${LINE}" | tail -n +3 | head -n -7 | cut -d: -f2 | tr -d ' ' | tr '\n' ',')"
	args2="$(cat "${LINE}" | egrep 'This platform' | sed -E 's/This platform has an? //' | sed -E 's/ license\.//')"
	args3="$(cat "${LINE}" | tail -n 4 | cut -d: -f2 | tr -d ' ' | tr '\n' ',')"
	echo "${host_name},${args}${args2}${args3}" | tr -s ',' >> "${FILE}"
done< <(find "${DIR}" -type f -name "*.log")
