#!/bin/bash

[[ $# -eq 1 ]] || { echo "Invalid number of arguments!"; exit 1; }

DIR="${1}"

if [[ ! -d "${DIR}" ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r "${DIR}" ]];then
	echo "Directory nit readable!"
	exit 3
fi

if [[ $(find "${DIR}" -mindepth 1 | wc -l) -eq 0 ]];then
	echo "Directory is empty!"
	exit 4
fi

echo "" >> "${DIR}"/foo.conf
T=$(mktemp)

while read filename;do
	${DIR}/validate.sh ${filename} > ${T}

	if [[ $? -eq 0 ]];then
		cat ${filename} >> ${DIR}/foo.conf

		name=$(basename "${filename}")
		isPresent=$(cat ${DIR}/foo.pwd | egrep "${name}")
		if [[ -z ${isPresent} ]];then
			pass=$(pwgen 5 1)
			hash=$(mkpasswd ${pass})
			echo "${name}:${pass}"
			echo "${name}:${hash}" >> ${DIR}/foo.pwd
		fi
	elif [[ $? -eq 1 ]];then
		cat ${T} | awk -v name=${filename} '{print name":"$0}' 1>&2
	else
		continue
	fi
done< <(find ${DIR}/cfg -type f -name "*.cfg")

rm ${T}
