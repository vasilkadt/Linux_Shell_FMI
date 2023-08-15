#!/bin/bash

ACCOUNT="$(whoami)"

[[ "${ACCOUNT}" != "oracle" ]] || [[ "${ACCOUNT}" != "grid" ]] || { echo "Invalid account!"; exit 1; }

adrci="${ORACLE_HOME}/bin/adrci"

if [[ $(${adrci} exec = "show homes") != "No ADR homes are set" ]];then
	for line in $(${adrci} exec = "show homes" | tail -2);do
		size=$(stat -c "%s")
		echo "${size} u01/app/${ACCOUNT}/${line}"
	done
fi

