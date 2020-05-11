#!/bin/bash

directory=$1
number=$2

if [[ -d "${directory}" ]]; then
	if [[ "${number}" =~ ^[[:digit:]]$ || "${number}" =~ ^[1-9][[:digit:]]*$ ]]; then
		sum=$(find "${directory}" -type f -size +"${number}"c -printf "+%s" | cut -c 2- | bc )
		echo "The sum of the sizes of the files, larger than the given paramter is ${sum}."
	else
		echo "Invalid number" 2&>1
	fi
else
	echo "$directory does not exist on this system" 2&>1
fi
