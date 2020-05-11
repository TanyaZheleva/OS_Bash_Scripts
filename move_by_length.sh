#!/bin/bash

validate_arg(){
	number="$1"
	if [[ ("$number" =~ ^0$ ) || ("$number" =~ ^-?[1-9]$) || ("$number" =~ ^-?[1-9][0-9]+$) ]]; then
                return 0
	else
		return 1
	fi
}

if [ "$#" -eq 2 ]; then
	if validate_arg "$2" && validate_arg "$1"; then
		if [ "$1" -le "$2" ]; then
			left="$1"
			right="$2"
		else
			left="$2"
			right="$1"
		fi
		mkdir {a..c}
		while read length name ; do
		if [ "${length}" -lt "$1" ]; then
			mv "${name}" ./a
		elif [[ "${length}" -gt "$left" && "${length}" -lt "${right}" ]]; then
			mv "${name}" ./b
		else
			mv "${name}" ./c
		fi

		done< <(find . -type f -exec wc -l '{}' \;)
	else
		echo "invalid arguments" 2&>1
        	exit 1
	fi

else
	echo "invalid arguments" 2&>1
	exit 1
fi
