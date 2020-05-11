#!/bin/bash

read -p "Enter pathname to directory: " pathname

if [[ -d "$pathname" ]]; then
	echo "Number of files and directories in $pathname is: $(find "$pathname" -mindepth 1 | wc -l)."
else 
	echo "$pathname is not a directory."
fi
