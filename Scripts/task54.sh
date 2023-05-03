#!/bin/bash

if [[ $# -gt 1 ]];then
	echo "Invalid number of arguments!"
	exit 1
fi

if [[ $(whoami) != "root" ]];then
	echo "Script must be executed as root!"
	exit 2
fi

tmpfile=$(mktmp)

if [[ -z "${CTRLSLOTS}" ]];then
	slots="0"
else 
	slots="$(echo ${CTRLSLOTS} | cut -d '=' -f2)"
fi

if [[ $# -eq 0 ]];then
	while read -d ' ' num;do
		ssacli ctrl slot=${num} pd all show detail | awk '$1=="Smart" {model=$3;slot=$6} \
			$1=="Unsigned" {name=$2} \
			$1=="physicaldrive" {drive=$2} \
			$1=="Current" {temp=$4;print "SSA" slot model name drive ".value" temp}' | sed 's/://g'
	done <<< "${slots}"
else
	if [[ "${1}" == "autoconf" ]];then
		echo "yes"
	elif [[ "${1}" == "config" ]];then
		echo "graph_title SSA drive temperatures"
		echo "graph_vlabel Celsius"
		echo "graph_category sensors"
		echo "graph_info This graph shows SSA drive temp"

		while read -d ' ' num;do
		ssacli ctrl slot=${num} pd all show detail | awk '$1=="Smart" {model=$3;slot=$6} \
			$1=="Unsigned" {name=$2} \
			$1=="physicaldrive" {drive=$2;print "SSA" slot model name drive ".label SSA0" slot,model,name,drive "\n" "SSA" slot model name drive ".type GAUGE"}' | sed -E 's/(^.+):(.+):(.+\.)/\1\2\3/g'
		done <<< "${slots}"	
	fi
fi

