#!/bin/bash

most_recent_for_all_users=$(mktemp)

while read user home; do

	[ -d "${home}" ] || continue
	[ -r "${home}" ] || continue

	cur_file="$(find "${home}" -type f ! -name ".*" -printf "%T@ %f\n" 2>/dev/null | sort -n -t' ' -k1 | tail -1)"

	[ -n "${cur_file}" ] || continue

	echo "${user} ${cur_file}" >> "${most_recent_for_all_users}"

done < <(cat /etc/passwd | cut -d ':' -f 1,6 | tr ':' ' ')

cat "${most_recent_for_all_users}" | sort -n -t' ' -k2 | tail -1 | cut -d' ' -f1

rm -- "${most_recent_for_all_users}"
