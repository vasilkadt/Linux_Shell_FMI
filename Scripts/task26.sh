#!/bin/bash

if [[ $(whoami) != "root" ]]; then
	echo "This script must be executed as root!"
	exit 1
fi

for user in $(ps -eo user= | sort | uniq);do
	countPS=$(ps -u ${user} -o pid=| wc -l)
	avgRSS=$(ps -u ${user} -o rss= | awk 'BEGIN{total=0}{total=total+$1}END{print total}')
	allRSS=$( ps -u ${user} -o rss=| awk -v user=${user} -v countPS=${countPS} '{countRSS+=$1} END {print user,countPS,countRSS}')
	process_with_greater_RSS=$(ps -u ${user} -o rss= | sort -nr | head -1)
    process_with_greater_RSS_PID=$(ps -u ${user} -o rss=,pid= | sort -nr -t' ' -k1 | head -1 | cut -d' ' -f2)

    echo "User ${user} has ${countPS} processes and ${allRSS} RSS\n"

	if [[ ${process_with_greater_RSS} -gt $(expr avgRSS * 2) ]];then
		echo "killing process ${process_with_greater_RSS_PID}"
		kill -s SIGTERM ${process_with_greater_RSS_PID}
	fi
done
