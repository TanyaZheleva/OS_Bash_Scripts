#!/bin/bash

directory=$1
read -p "Press a to list hidden files too: " check 

if [[ -d "${directory}" ]]; then
	if [[ "${check}" == "a" ]]; then
		while read perm size name; do
			if [[ "${perm}" =~ ^d ]];then
				size=$(ls -al "${name}" | head -n1 | cut -d " " -f2)
				echo "${name} (${size} entries)"
			elif [[ "${perm}" =~ ^- ]];then
				echo "${name} (${size} bytes)"
			fi
		done < <(ls -al | awk '{print $1" "$5" "$9}') 
	else
		while read perm size name; do
			if [[ "${perm}" =~ ^d ]];then
                                size=$(ls -l "${name}" | head -n1 | cut -d " " -f2)
                                echo "${name} (${size} entries)"
                        elif [[ "${perm}" =~ ^- ]];then
                                echo "${name} (${size} bytes)"
                        fi
                done < <(ls -l | awk '{print $1" "$5" "$9}')

	fi
else
	echo "${directory} is not a directory." 2&>1
fi
