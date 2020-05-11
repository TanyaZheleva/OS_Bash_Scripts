#!/bin/bash

directory=$1
size=$2

if [[ -d "${directory}" ]]; then
	echo "Files in ${directory} larger than ${size}:"
	find "${directory}" -type f -size +"${size}"c -printf "%f\n"
else
	echo "${directory} is not an existing direcotry." 2&>1
fi
