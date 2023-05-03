#!/bin/bash

if [[ ! $1 ~= ^[0-9]+$ ]]; then
	echo "All parameters must be numbers!"
	exit 1;
fi

if [[ ! $2 ~= ^[0-9]+$ ]]; then
	echo "All parameters must be numbers!"
	exit 2;
fi

if [[ $# != 2 ]]; then
	echo "Parameters must be two!"
	exit 3
fi

mkdir -p a b c

#if string is empty exit the code and no need for iterating through while cycle
findd=$(find . -type f)
if [[ -z ${findd} ]]; then
	exit 4
fi

while read filename; do
	rows=$(wc -l ${filename} | awk '{print $1}')
	if [[ ${rows} =lt ${1} ]]; then
		mv ${filename} a
	elif [[ ${rows} =lt ${2} ]]; then 
		mv ${filename} b
	else
		mv ${filename} c
	fi
done < <(find . -type f)
