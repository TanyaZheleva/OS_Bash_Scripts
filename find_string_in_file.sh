#!/bin/bash

read -p "Enter string to look for in files: " string

while [[ "$#" -gt 0 ]]; do
	if [[ -f "${1}" ]]; then
		count_matched_lines=$(grep -c "$string" "${1}" )
		echo "${1} has $count_matched_lines matched lines."
	else
		echo "${1} is not a file." 2&>1
	fi
	shift
done
