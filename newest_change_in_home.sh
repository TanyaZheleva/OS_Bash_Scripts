#!/bin/bash

tempfile=$(mktemp ./tempXXXX)
awk -F ":" '{print $1" "$6}' /etc/passwd > "${tempfile}"
newest_files=$(mktemp newestXXXX)
while read user directory; do
	if [ -d "${directory}" ]; then
		line=$(find "${directory}" -maxdepth 1 -type f -printf "%T@ %f\n" 2>/dev/null | sort -n | head -n1)
		if [ -n "${line}" ]; then
			line+=" ${user}"
	       		echo "${line}" >> "${newest_files}"
		fi
	fi
done< <(cat "${tempfile}")
sort -n "${newest_files}" | head -n1 | awk '{print $2" " $3}'

rm "${tempfile}"
rm "${newest_files}"
