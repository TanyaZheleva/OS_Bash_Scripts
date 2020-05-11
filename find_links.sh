#!/bin/bash

if [ "$#"  -eq 1 -a -d "$1" ]; then
	find "$1" -type l -exec file '{}' \; | grep " broken symbolic link to " | cut -d ":" -f 1
elif [ "$#" -eq 2 -a -d "$1" ]; then
	if [[ "$2" =~ ^[[:digit:]]*$ ]]; then 
		while read hlinks file; do
			if [ "${hlinks}" -ge "$2" ]; then
				echo "${file}"
			fi
		done< <(find "$1" -printf "%n %f\n")
	fi
fi
