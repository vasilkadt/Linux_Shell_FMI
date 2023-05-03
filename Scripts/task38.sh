#!/bin/bash

[[ $# -eq 2 ]] || { echo "Invalid number of arguments!"; exit 1; }

DIR1="${1}"
DIR2="${2}"

if [[ ! -d "${DIR1}" ]];then
	echo "Invalid directory name!"
	exit 2
elif [[ ! -r "${DIR1}" ]];then 
	echo "Directory not readable!"
	exit 3
fi

if [[ ! -d "${DIR2}" ]];then
	echo "Invalid directory name!"
    exit 4
elif [[ ! -r "${DIR2}" ]];then
	echo "Directory not readable!"
    exit 5
fi

[[ $(find "${DIR1}" -mindepth 1 | wc -l) -ne 0 ]] || { echo "Directory is empty!"; exit 6; }
[[ $(find "${DIR2}" -mindepth 1 | wc -l) -ne 0 ]] || { echo "Directory is empty!"; exit 7; }

package_archive=$(tar --xz -cf packqage.tar.xz "${DIR2}/tree")
package_verson=$(cat "${DIR2}/version")

if egrep "${package_verson}" "${DIR1}/db" ;then
	package_checksum=$(sha256sum ${package_archive})
	old_checksum=$(egrep "${package_verson}" "${DIR1}/db" | cut -d' ' -f2)
	sed "s/${old_checksum}/${package_checksum}/g" "${DIR1}/db"
	sed "s/${old_checksum}/${package_checksum}/g" "${DIR1}/packages"
else
	 package_checksum=$(sha256sum ${package_archive})
	 echo "${DIR2}-${package_verson} ${package_checksum}" >> "${DIR1}/db"
	 echo "${package_checksum}.tar.xz" >> "${DIR1}/packages"
fi

