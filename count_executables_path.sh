#!/bin/bash

count=0
OLD_IFS="${IFS}"
IFS=":"

while read -d":" directory; do
	IFS="${OLD_IFS}"
	files=($(find "${directory}" -type f -exec grep -l '^#!/bin/' '{}' \; 2>/dev/null | tr '\n' ' '))
	for j in "${files[@]}"; do
		if [[ -e "${j}" ]]; then
			(( ++count ))
		fi
	IFS=":"
	done	
done< <(echo "${PATH}")

IFS="${OLD_IFS}"
echo "The count of the executable files in PATH is ${count}."
