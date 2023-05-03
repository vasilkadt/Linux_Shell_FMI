#!/bin/bash

if [[ ${#} -ne 2 ]]; then
  echo "Arguments must be two!"
  exit 1
fi

if [[ ! -f "$1" ]] || [[ ! -f "$2" ]]; then
	echo "Not files"
	exit 2
fi

lines1=$(cat ${1} | egrep "${1}" | wc -l)
lines2=$(cat ${2} | egrep "${2}" | wc -l)

if [[ ${lines1} -ge ${lines2} ]]; then
	winner=${1}
else
	winner=${2}
fi

cat ${winner} | cut -d ' ' -f 4- | sort > "${winner}.songs"
