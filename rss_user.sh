#!/bin/bash

if [ "$#" -eq 1 ]; then
	if [[ "$1" =~ [[:digit:]]+ ]]; then
		if [ "$EUID" -eq 0 ]; then
			number="$1"
			tempfile1=$(mktemp ./temp.XXX)
			tempfile2=$(mktemp ./temp.XXX)
			ps -e -o uid= -o pid= -o  rss= | sort -t " " -k1 -n | tr -s " " > "${tempfile1}"

			awk '{sum_rss[$1]+=$2} END {for (i in sum_rss) print i,sum_rss[i]}' "${tempfile1}" > "${tempfile2}" 
			cat "${tempfile2}" | while read id val; do

			if [ "${val}" -gt "${number}" ]; then
				egrep "^[ ]*${id} " "${tempfile1}" | sort -t " " -k4 -nr | head -n1 |awk '{print $2}' | xargs kill -9 
			fi
		done
		rm "${tempfile1}"
		rm "${tempfile2}"
		fi
	fi
fi
