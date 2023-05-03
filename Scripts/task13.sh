#!/bin/bash

if [ ! -f $1 ];then
    echo "Wrong argument passed!"
    exit 1
fi

mostfailures=$(cat $1 | egrep 'Failure' | cut -d'|' -f2 | sort | uniq -c | tr -s ' ' | cut -d' ' -f3)

cat $1 | egrep '$mostfailure' | sort -nr -t '|' -k1 | head -1 | cut -d'|' -f3,4 | sed 's/|/:/g'
