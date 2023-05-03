#!/bin/bash

if [[ ${#} != 1 ]]; then
	echo "Argument must be one!"
	exit 1
fi

if [[ -d ${1} ]]; then
	find ${1} -L -type l
fi

#-L find all broken symlinks
