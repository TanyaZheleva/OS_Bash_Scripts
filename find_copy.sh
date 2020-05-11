#!/bin/bash

read -p "Enter directory name: " directory
read -p "Enter a filename: " filename


if [[ -d "${directory}" && -f "${filename}" ]]; then
	find "${directory}" -type f -exec diff -qs "${filename}" '{}' \; 2>/dev/null | grep "are identical" | awk '{print $4}'
else
	echo "One or more parameters invalid."  
fi
