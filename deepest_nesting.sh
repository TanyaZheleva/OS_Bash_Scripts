#!/bin/bash

file="${1}"
opened=0
max_depth=0

if [[ -e "${file}" ]]; then
	while read p; do
		if [[ "${p}" == "{" ]]; then 
			((++opened))
			if [[ "${opened}" -gt "${max_depth}" ]]; then
				((max_depth="${opened}"))
			fi
		else
			((--opened))
		fi
	done< <(fold -w1 "${file}" | grep -on "[{}]" | sort -t: -k1 -n | cut -d: -f2)
	echo "The deepest nesting is ${max_depth} levels" 

else
	echo "File doesn't exist or isn't a .c file" 2>&1
	exit 1
fi
