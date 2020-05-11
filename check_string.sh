#!/bin/bash

read -p "Enter filename and a string to check for: " filename string

echo "name is $filename."
echo "string is $string."
#path=$(realpath "$filename")

if [ -e "${filename}" ];then
	egrep "${string}" "${filename}"
	echo "Comand exited with ${?}."
else
	echo "File doesn't exist." 2&>1
fi
