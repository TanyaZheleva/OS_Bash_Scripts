#!/bin/bash

if [ "$#" -eq 2 ]; then
	if [[ -f "$1" && -f "$2" ]]; then
		count1=$(cut -d " " -f 2 "$1" | grep -c "$1" "$1")
		count2=$(cut -d " " -f 2 "$2" | grep -c "$2" "$2")

		if [ "${count1}" -ge "${count2}" ]; then
			filename="$1"
		else
			filename="$2"
		fi
		tempfile=$(mktemp ./temp.XXXX)
		cut -d " " -f 4- "${filename}" | sort > "${tempfile}"
		mv "${tempfile}" "${filename}"
	else
		echo "invalid arguments" 2&>1
		exit 1
	fi
else
	echo "Wrong count argumants" 2&>1
	exit 1
fi

