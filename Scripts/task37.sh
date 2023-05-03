#!/bin/bash

[[ $# -eq 1 ]] || { echo "Invalid number of arguments!"; exit 1; }

FILE="${1}"

if [[ ! -f "${FILE}" ]];then
	echo "Invalid file name!"
	exit 2
elif [[ ! -r "${FILE}" ]];then
	echo "File not readable!"
	exit 3
fi

sites_file=$(mktemp)

cat "${FILE}" | cut -d' ' -f2 | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}' >> "${sites_file}"

while read LINE;do
	count_http=$(cat "${FILE}" | egrep \<${LINE}\> | egrep -c 'HTTP/2.0')
	count_nonhttp=$(cat "${FILE}" | egrep ${LINE} | egrep -vc 'HTTP/2.0')
	clients=$(cat "${FILE}" | egrep ${LINE} | awk '$9>302 {print $1}' | sort | uniq -c | sort -nr | head -n 5)
	echo -e "${LINE} HTTP/2.0: ${count_http} non-HTTP/2.0: ${count_nonhttp}\n"
	echo -e "${clients}\n"
done< "${sites_file}"
