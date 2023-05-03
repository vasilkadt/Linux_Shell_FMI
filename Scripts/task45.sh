#!/bin/bash
 
if [[ "$(whoami)" != "oracle" -a "$(whoami)" != "grid" ]]; then
    echo "Not right user." >&2
    exit 1
fi
 
if [ "$#" -ne 1 ]; then
    echo "Only 1 argument is required" >&2
    exit 2
fi
 
if [ "$1" -lt 2 ]; then
    echo "$1 is less than 2" >&2
    exit 3
fi
 
diag_dest="/u01/app/$(whoami)"
 
if ($ORACLE_HOME/bin/adrci exec="SET BASE $diag_dest; SHOW HOMES" | egrep -q "No ADR homes are set"); then
    exit 0
fi
 
while read line; do
    cutDir="$(echo $line | cut -f 2 -d '/')"
    if [[ $cutDir == "crs" -o $cutDir == "tnslsnr" -o $cutDir == "kfod" -o $cutDir == "asm" -o $cutDir == "rdbms" ]]; then
        $ORACLE_HOME/bin/adrci exec="SET BASE $diag_dest; SET HOMEPATH $line; PURGE -AGE $(($1*60))" 
    fi
done< <$($ORACLE_HOME/bin/adrci exec="SET BASE $diag_dest; SHOW HOMES" | tail -n +2)
exit 0
