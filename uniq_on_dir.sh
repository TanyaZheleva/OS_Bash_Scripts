#!/bin/bash

read -p "Enter directory name: " directory

if [[ -d "${directory}" ]]; then
       files=($(find "${directory}" -type f -printf "%p " 2>/dev/null))
       for i in "${files[@]}"; do
	       echo "In for loop with $i"
	       copies=( $(find "${directory}" -type f -exec diff -qs "$i" '{}' \; 2>/dev/null | grep "are identical" | awk '{print $4}' | sort | tr '\n' ' '))
	       echo "${#copies[@]}"
	       if [[ "${#copies[@]}" -gt 1 ]]; then
		       index=0
		       for j in "${copies[@]}"; do
			      if [[ "$index" -gt 0 ]]; then 
				      rm "$j"
			      fi
			      (( ++index ))
		       done
	       fi
       done
else
        echo "Directory doesn't exist" 2&>1
fi

