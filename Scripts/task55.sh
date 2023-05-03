#!/bin/bash

if [[ $# -ne 1 ]];then
	echo "Invalid number of arguments!"
	exit 1
fi

if [[ ! -d "${1}" ]];then
	echo "Invalid diretory name!"
	exit 2
fi

if [[ $(find "${1}" -mindepth 1 | wc -l) -eq 0 ]];then
	echo "${1} is empty!"
	exit 3
fi

DIR=$1
OUTPUT=$(mktemp)
hashs=$(mktemp)
 
for file in $(find $DIR -type f );do
        hash=$(sha256sum $file)
        echo "$hash $(stat -c "%i" $file)" >> $hashs
done
 
while read hash;do
        countAll=$(grep -Fc "$hash" $hashs)
        uniqHashs=$(grep -F "$hash" $hashs | awk '{print $3}' | sort | uniq | wc -l)
 
        if [[ ${countAll} -eq ${uniqHashs} ]];then
                grep -F "$hash" $hashs |cut -d' ' -f 2 |tail -n +2 >> $OUTPUT
        elif [[ ${uniqHashs} -eq 1 ]];then
                grep -F "$hash" $hashs |cut -d' ' -f 2 |head -n 1 >> $OUTPUT
        else
                while read inode;do
                        countInodes=$(grep -Fc "$inode" $hashs)
 
                        if [[ ${countInodes} -eq 1 ]];then
                                grep -F "$inode" $hashs | cut -d' ' -f 2 >> $OUTPUT
                        else
                                grep -F "$inode" $hashs | cut -d' ' -f 2 | head -n 1 >> $OUTPUT
                        fi
                done < <(grep -F "$hash" $hashs |cut -d' ' -f 3 | sort | uniq)
        fi
done < <(cat $hashs | awk '{print $1}' | sort | uniq)
 
cat $OUTPUT
 
rm $hashs
rm $OUTPUT
