#!/bin/bash
 
if [[ "$(whoami)" != "oracle" ]] && [[ "$(whoami)" != "grid" ]]; then
    echo "Not right user." >&2
    exit 1
fi
 
if [ "$#" -ne 1 ]; then
    echo "Only 1 argument is required" >&2
    exit 2
fi

if [[ -z ${ORACLE_HOME} ]] && [[ -z ${ORACLE_BASE} ]] && [[ -z ${ORACLE_SID} ]];then
	 echo "Environment variables should be non-empty strings" >&2
	 exit 3
fi

if [[ ! -f ${ORACLE_HOME}/bin/sqlplus ]] && [[ ! -x ${ORACLE_HOME}/bin/sqlplus ]];then
	echo "File sqlplus not found!"
	exit 4
fi

function validate_num {
	egrep -q '^[0-9][1-9]+$' <(echo "${1}")
}

foo=$(mktemp)
echo "SELECT value FROM v\$parameter WHERE name = 'diagnostic_dest';" > "${foo}"
echo "EXIT;" >> "${foo}"

if validate_num "${1}" ; then
     if [[ "$(whoami)" == "oracle" ]];then
		 diagnostic_dest=$("${ORACLE_HOME}/bin/sqlplus" sqlplus -SL "/ as sysdba" "@foo.sql"  | sed -n '4p')
     elif [[ "$(whoami)" == "grid" ]];then
	   diagnostic_dest=$("${ORACLE_HOME}/bin/sqlplus" sqlplus -SL "/ as sysasm" "@foo.sql" | sed -n '4p')
     fi
else
	echo "Inavlid number argument!"
	exit 5
fi

if [[ $? -ne 0 ]];then
	echo "Script do not execute successfully!"
	exit 6
fi
 
if [[ -z ${diagnostic_dest} ]];then
	diag_base=${ORACLE_BASE}
else
	diaag_base=${diagnostic_dest}
fi

if [[ ! -d ${diag_base}/diag ]];then
	echo "Directory diag does not exist!"
	exit 7
else
	diag_dir="${diag_base}/diag"
fi

if [[ "$(whoami)" == "oracle" ]];then
	size=$(find "${diag_dir}/rdbms/" -maxdepth 2 -mindepth 2 -regex "^.*_[0-9]+\.(trc|trm)$" -mtime +"${1}" -printf "%s\n" | awk 'BEGIN{sum=0} {sum=sum + $1} END {print sum/1024}')
	echo "rdbms: ${size}"
elif [[ "$(whoami)" == "grid" ]];then
	name=$(hostname -s)
	size=$(find "${diag_dir}/crs/${name}/crs/trace" -regex "^.*_[0-9]+\.(trc|trm)$" -mtime +"${1}" -printf "%s\n" | awk 'BEGIN{sum=0} {sum=sum + $1} END {print sum/1024}')
	echo "crs: ${size}"
	regex_alert="^/alert/.*_[0-9]+\.xml$"
	regex_trace="^/trace/.*_[0-9]+\.log"
	size2=$(find "${diag_dir}/tnslsnr/${name}" -maxdepth 3 -mindepth 3 -regex "(${regex_alert}|${regex_trace})" -mtime +"${1}" -printf "%s\n" | awk 'BEGIN{sum=0} {sum=sum + $1} END {print sum/1024}')
	echo "tnslsnr: ${size}"
fi

