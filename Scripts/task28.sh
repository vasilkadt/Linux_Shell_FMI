#!/bin/bash

if [[ $# -eq 0 ]] || [[ $# -gt 2 ]]; then
	echo "Invalid number of arguments!"
	exit 1
fi

dir="${1}"
file=""

if [[ $# -eq 2 ]]; then
	file="${2}"
	if [[ ! -f "${file}" ]]; then
		echo "Invalid file!"
		exit 2
	elif [[ ! -w "${file}" ]]; then
		echo "File is not writable!"
		exit 3
	fi
fi

if [[ ! -d "${dir}" ]]; then
	echo "Invalid directory!"
	exit 4;
elif [[ ! -r "${dir}" ]]; then
	echo "Directory is not readable!"
	exit 5;
fi

cnt=0

while read symlink; do
	if egrep -q "broken" <(echo "${symlink}"); then
		cnt=$(expr $cnt '+' 1)
	else
		if [[ -n "${file}" ]]; then
			stat -c "%N" "$(echo "${symlink}" | cut -d':' -f1)" | tr -d "\'" >> "${file}"
		else
			stat -c "%N" "$(echo "${symlink}" | cut -d':' -f1)" | tr -d "\'"
		fi
	fi
done < <(find "${dir}" -type l 2>/dev/null -exec file {} \;)

if [[ -n "${file}" ]]; then
	cat "${file}"
fi

echo "Broken symlinks: ${cnt}"
s0600024@astero:~$ cat zad28.sh
#!/bin/bash

if [[ $# -ne 2 ]];then
	echo "Arguments should be 2!"
	exit 1
fi

if [[ ! -d $1 ]];then
	echo "Argument 1 should be directory!"
	exit 2
fi

if [[ -z $2 ]];then
	echo "Argument 2 should be non empty string!"
	exit 3
fi

find $1 -type f -maxdepth 1 -printf "%f\n" | egrep "^vilinuz-[0-9]+\.[0-9]+\.[0-9]+-$2\$"|sort|tail -n 1
