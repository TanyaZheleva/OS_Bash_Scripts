#!/bin/bash

max=0
i=1
max1=$(mktemp max_numbers_1_XXXX)
max2=$(mktemp max_numbers_2_XXXX)
while read number; do
	if [[  "${number}" =~ ^-?[1-9][0-9]*$ ]]; then
		if [ "${number}" -lt 0 ]; then
			(( number=number*(-1) ))
			if [ "$number" == "$max" ]; then
				(( number=number*(-1) )) >> "${max}${i}"
			elif (( number > max )); then 
				max="$nummber"
				if [ "$i" -eq 1 ]; then
					(( ++i))
				else
					(( --i))
				fi
				(( number=number*(-1) )) > "${max}${i}"
			fi
		else
			if [ "$number" == "$max" ]; then
                                echo "$number" >> "${max}${i}"
			elif (( number > max )); then
                                max="$nummber"
                                if [ "$i" -eq 1 ]; then
                                        (( ++i))
                                else
                                        (( --i))
                                fi
                                echo "$number" > "${max}${i}"
                        fi
		fi
	fi
done < <(cat)

echo "$(sort "${max}${i}" | uniq )" 

rm "${max1}"
rm "${max2}"
