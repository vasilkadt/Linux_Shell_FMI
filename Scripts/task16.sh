#!/bin/bash

if [[ $# != 1 ]]; then
	echo "There must be only one parameter!"
	exit 1;
fi

if [[ ! $1 =~ ^[0-9]+$ ]]; then
	echo "The parameter must be number!"
	exit 2;
fi

if [[ $(whoami) != "root" ]]; then
	echo "This script must be executed by root!"
	exit 3;
fi

for user in $(ps -eo user= | sort | uniq); do
	process=$(ps -u $user -o pid=,rss= | sort -t ' ' -k 2 -n | awk '{count+=$2} END {print count,$1}}')

	pid=$(echo $process | cut -d ' ' -f 2)
	mem=$(echo $process | cut -d ' ' -f 1)

	[[$mem -gt $1]] && echo "$pid" #kill ${pid}
done
