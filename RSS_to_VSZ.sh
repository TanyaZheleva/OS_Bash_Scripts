#!/bin/bash

user=$1
found=$(grep -o "^$1:" /etc/passwd | rev | cut -c 2- | rev)
if [[ "$found" == "$user" ]]; then
	ps -hU "$user" -o rsz,vsz --sort -vsz | awk 'val=$1/$2 {printf "%0.2f\n",val}'
else
	echo "$user is not a valid entry." 2&>1
fi
