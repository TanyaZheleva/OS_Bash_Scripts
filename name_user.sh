#!/bin/bash

id=$(ps --pid=$$ -o ruid --no-headers | awk '{print $1}')
name=$(grep ":$id:" /etc/passwd | cut -f 1 -d ":")
owner=$(stat -c '%U' "$0")

if [[ $name == $owner ]]; then
	echo "Name is $name, same as owner."
else
	echo "Danger! Name is $name, different from owner $owner."
fi

