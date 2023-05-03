#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1; }

if [[ ! -f ${1} ]];then
	echo "Invalid file name!"
	echo 2
fi

size=$(stat -c "%s" "${1}")
if [[ $(( size % 2 )) != 0 ]] ;then
	echo "Invalid file size!"
	exit 3
fi

if [[ ! -f ${2} ]];then
	echo "Invalid file name!"
	exit 4
fi

if [[ ${size} -gt 524288 ]];then
	echo "Invalid file!"
	exit 5
fi

echo -e "#include <studio.h>\n" >> ${2}
arrN=$(echo "${size}/2" | bc)
echo -e "const unit32_t arrN = ${arrN}/2;\n" >> ${2}
echo -e "const unit16_t arr[] = {\n" >> ${2}

count=0
for num in $(xxd ${1} | cut -c 10-49);do
	last=$(echo "${num}" | egrep -o "..$")
	first=$(|echo "${num}" | egrep -o "^..")

	new="0x${last}${first}"
	
	if [[ count -eq 0 ]];then
		echo -ne "${new}" >>${2}
	else
		$(( count++ ))
		echo -ne ",${new}" >> ${2}
	fi
done
