#!/bin/bash

if [ "$#" -eq 1 -a "$EUID" -eq 0 ]; then
	my_user="$1"
	tempfile1=$(mktemp ./tempfXXXX)
	tempfile2=$(mktemp ./tempfXXXX)
	ps -e -o user,pid,time | tail -n +2 > "${tempfile1}"
	awk '{sum_processes[$1]+=1} END {for (i in sum_processes) print i,sum_processes[i]}' "${tempfile1}" > "${tempfile2}"
	my_processes=$(egrep "^${my_user}" "${tempfile2}" | awk '{print $2}')

	while read user count; do 
		if [ "${count}" -gt "${my_processes}" ]; then
			echo "${user}"
		fi
	done< <(cat "${tempfile2}")
	rm "${tempfile1}"
	rm "${tempfile2}"
else
	echo "Invalid user" 2&>1
	exit 1
fi
