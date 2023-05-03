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
s0600024@astero:~$ cat zad20.sh
#!/bin/bash

if [[ ${#} -ne 1 ]]; then
	echo "Argument must be 1!"
	exit 1
fi

if [[ ! -f "$1" ]]; then
	echo "Not file"
	exit 2
fi

cat ${1} | cut -d ' ' -f 4- | awk '{print NR ". " $0}' | sort -k 2
