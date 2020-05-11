#!/bin/bash

check_path(){
	filename="$1"
	mkdir -p $(echo "${filename}" | rev | cut -d "/" -f2- | rev) 2>/dev/null
}

if [ "$#" -eq 3 -a -d "$1" -a -d "$2" ]; then
	if [ "$EUID" -eq 0 ]; then
		src="$1"
		dst="$2"
		string="$3"
		from=$(mktemp tempfromXXXX)
		find "${src}" -type f -name "*$string*" 2>/dev/null > "${from}"
		sources=($(cat "${from}" | tr '\n' ' '))
		destinations=($(sed 's,\('"${src}"'\)\(.*\)$,'"$dst"'\2,g' "${from}" | tr '\n' ' '))
		for i in "${!destinations[@]}"; do
			check_path "${destinations[$i]}"
			mv "${sources[$i]}" "${destinations[$i]}"
		done
		rm "${from}"
	else
		echo "not root" 2&>1
		exit 2
	fi
else
	echo "wrong parameters" 2$>1
	exit 1
fi       


