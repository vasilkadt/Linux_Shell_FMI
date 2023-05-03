#!/bin/bash

[[ $# -eq 3 ]] || { echo "Invalid number of arguments!"; exit 1; }

digit="${1}"
prefix="${2}"
unit="${3}"

if $(echo "${digit}" | egrep -v '^[0-9]+.?[0-9]*$') ;then
	echo "Invalid first argument!"
	exit 2
fi

if [[ -z "${prefix}" ]];then
	echo "Argument should be non-empty string!"
	exit 3
elif [[ -z "${unit}" ]];then
	echo "Argument should be non-empty string!"
	exit 4
fi

decimal=$(egrep ",${prefix}," "prefix.csv" | cut -d',' -f3)
new_digit=$(echo "$digit * $decimal" | bc)
name_measure=$(egrep ",${unit}," "base.csv" | cut -d',' -f1,3)
measure_name=$(echo $name_measure | awk -F',' '{printf $2", "$1}')

echo "${new_digit} ${unit} (${measure_name})"

