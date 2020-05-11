#!/bin/bash

if [ "$#" -eq 1 -a -d "$1" ]; then
	friends=($(find "$1" -maxdepth 2 -mindepth 2 -type d | cut -d "/" -f 3 | sort | uniq | tr '\n' ' '))
	tempfile=$(mktemp temp_friends_XXXX)
	for i in "${!friends[@]}"; do
		echo "${friends[$i]} $(find dir3 -type d -name "${friends[$i]}" | xargs -I @ find @  -type f -exec wc -l '{}' \; | awk '{ sum+=$1 } END { print sum }')" >> "${tempfile}"
	done
	sort -t " " -k 2 -nr | head -n10
	rm "${tempfile}"
else
	echo "invalid directory" 2&>1
	exit 1
fi
