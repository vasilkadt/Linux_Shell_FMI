#!/bin/bash

if [[ ${#} -ne 1 ]]; then
	echo "Argument must be 1!"
	exit 1
fi

if [[ ! -f "$1" ]]; then
	echo "Not file"
	exit 2
fi

cat ${1} | cut -d ' ' -f 4- | awk '{print NR ". " $0}' | sort -k 2
