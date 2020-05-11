#!/bin/bash

check_empty(){
	count=$(find $1 | wc -l )
	if [ "${count}" -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

check_stenogram(){
	lines=$(wc -l "$1")
	matching_lines=$( egrep -c "^[abcdefghijklmnopqrstuvwxyz-ABCDEFGHIJKLMNOPQRSTUVWXYZ]+ *[abcdefghijklmnopqrstuvwxyz-ABCDEFGHIJKLMNOPQRSTUVWXYZ]+( *\(+.*\)+)*:.*$""$1")
	if [ "${matching_lines}" == "${lines}" ]; then
		return 0
	else
		return 1
	fi
}

if [ "$#" -eq 2 ]; then
	if [ -f "$1" -a -d "$2" ]; then
		if check_empty "$2"; then
			if check_stenogram "$1"; then
				touch "$2/dict.txt"
				cut -d ":" -f1 "$1" | cut -d "(" -f1 | sort | uniq | nl > "$2/dict.txt"
				while read number name1 name2; do
					grep "$name1 $name2" "$1" > "$2/${number}.txt"
				done< <(cat "$2/dict.txt" | tr -s " " | tr '\t' ' ')

			else
				echo "not a stenogram" 2&>1
				exit 4
			fi
		else
			echo "directory hass to be empty" 2&>1
			exit 3
		fi
	else 
		echo "directory or file doesn't exist" 2&>1
		exit 2
	fi
else
	echo "invalid count of arguments" 2&>1
	exit 1
fi
