#!/bin/bash

if [[ -f "$1" && -f "$2" ]]; then 
	if [[ -f "$3" ]]; then 
		cat "$1" "$2" "$3" | sort > "$3"
	else
		cat "$1" "$2" | sort > "$3"
	fi

else
	echo "One or more files is not a regular file" 2>&1
       exit 1
fi       
