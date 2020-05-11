#!/bin/bash

if [ "$#" -eq 2 ]; then
	if [ -d "$1" ]; then
		if [ -n "$2" ]; then
			find "$1" -maxdepth 1 -type f -printf "%f\n" | egrep "^vmlinuz-[[:digit:]]+.[[:digit:]]+.[[:digit:]]+-$2$" | sort -t "-" -k 2 -nr | head -n1
		else
			echo "cant have zero length string" 2&>1
			exit 3
		fi
	else
		echo "invalid directory" 2&>1
		exit 2
	fi
else
	echo "invalid count of arguments" 2&>1
	exit 1
fi
