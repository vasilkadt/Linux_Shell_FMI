#!/bin/bash

if [[ $(whoami) != "root" ]]; then
	echo "This script must be executed by root!"
	exit 1;
fi

for user in $(cat /etc/passwd | cut -d ':' -f 1,6); do
	username=$(echo ${user} | cut -d ':' -f 1)
	homedir=$(echo ${user} | cut -d ':' -f 2)
	if [[ ! -d ${homedir} ]]; then
		echo "This ${hoemdir} does not exist!"
	else
		perm=$(stat -c '%a' ${homedir} | cut -c 1)
		if [[ ! ${perm} =~ [7623] ]]; then
			echo "${username} does not have write permissions!"
		else
			echo "${username} has write permissions!"
		fi
	fi
done
