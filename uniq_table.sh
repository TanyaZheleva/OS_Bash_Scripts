#!/bin/bash

if [ "$#" -eq 2 ]; then
	patterns=$(mktemp temp_b_XXXX)
	cut -d"," -f2- "$1" | sort | uniq > "${patterns}"
	while read line;do
		count_matches=$(grep -c ",${line}" "$1")
		if [ "${count_matches}" -gt 1 ]; then
			grep ",${line}" "$1" | sort -t"," -k1 -n | head -n1 >> "$2"
		else
			grep ",${line}" "$1">> "$2"
		fi

	done< <(cat "${patterns}")

else
	echo "no" 2&>1
	exit 1
fi
