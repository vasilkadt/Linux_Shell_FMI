#!/bin/bash

options=""
args=""
values=""
name=""
state=0

for arg in "$@";do
	if [[ ${state} -eq 0 ]];then
		jar=$(echo "${arg}" | egrep "^\-jar$")
		if [[ -n "${jar}" ]];then
			state=1
		else
			opt=$(echo "${arg}" | egrep "^\-[^D]+")
			if [[ -n "${opt}" ]];then
				options="${options} ${opt}"
			fi
		fi
	elif [[ ${state} -eq 1 ]];then
		if [[ ${arg} =~ "^\-D.+=.+$" ]];then
			values="${values} ${arg}"
		elif [[ ${arg} =~ "^\-[^D]" ]];then
			options="${options} ${arg}"
		elif [[ ${arg} =~ "^[^\-]" ]];then
			if [[ -f ${arg} ]];then
				name=${arg}
				state=2
			fi
		fi
	else
		args="${args} ${arg}"
	fi
done

if [[ ${state} -eq 0 ]];then
	exit 1
else 
	java ${options} ${values} -jar ${name} ${args}
fi
