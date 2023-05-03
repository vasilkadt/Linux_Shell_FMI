#!/bin/bash

[[ $# -eq 1 ]] || {echo "Invalid number of arguments!"; exit 1; }

DIR1="${1}"

if [[ ! -d "${DIR1}" ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r "${DIR!}" ]];then
	echo "Directory not readable!"
	exit 3
fi

[[ $(find "${DIR!}" -mindepth 1 | wc -l) -ne 0]] || {echo "Directory is empty!"; exit 4}

hashes="${DIR}/hash.txt"
tmp="$(mktemp)"

touch "$hashes"
cat "$hashes" > "$tmp"
echo > "$hashes"

while IFS="" read -d $'\0' file; do
        sum="$(sha256sum "$file" | cut -d ' ' -f 1)"

        echo "${sum}  ${file}" >> "$hashes"

        if grep -qxF "${sum}  ${file}" "$tmp"; then
                # file already processed
                continue
        fi

        meow="$(tar -tzf "$file" | egrep '/meow.txt$' | head -n 1)"

        if [[ -n "$meow" ]]; then
                tar -xzOf "$file" "$meow" > "${DIR}/extracted_$(basename "$file" | sed -E 's/^([^_]*).*/\1/')_$(basename "$file" | sed -E 's/.*_report-([0-9]+).*/\1/').txt"
        fi
done < <(find $1 -type f -name '*_report-*.tgz' -print0 | egrep -z '/[^_]*_report-[1-9][0-9]*\.tgz$')

rm "$tmp"
