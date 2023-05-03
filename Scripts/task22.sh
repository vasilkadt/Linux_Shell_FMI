#!/bin/bash

if [[ $# -ne 1 ]];then
	echo "Arguments must be 1!"
	exit 1
fi

if [[ $(whoami) != "root" ]];then
	echo "This script must be executed as root!"
	exit 2
fi

#a)
userPsCount=$(ps -u $1 | wc -l)
for user in $(ps -eo user= | sort | uniq -c);do	
	if [[ $(echo "$user" | awk '{print $1}') -gt $userPsCount ]];then
		echo "$user" | awk '{print $2}'
	fi
done

#b)
avgTime=$(ps -eo times= | awk 'BEGIN{total=0}{total=total+$1}END{print (total/NR)*2}')
echo $avgTime

#c)
while read line;do
	flag=$(echo "$line" | awk -v avg=$avgTime '{if(avg<$3)}{print 1}')
    if [ $flag -eq 1 ];then
        kill -KILL $(echo "$line" | awk '{print $2}')
        echo "KILL process of user: $(echo "$line" | awk '{print $1}') pid: $(echo "$line" | awk '{print $2}')"
    fi
done < <(ps --user $1 -o user=,pid=,times=)
