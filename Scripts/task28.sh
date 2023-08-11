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
