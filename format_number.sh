#!/bin/bash

number=$1
delimiter=$2

validate_input(){
        if [[ ("$number" =~ ^0$ ) || ("$number" =~ ^-?[1-9]$) || ("$number" =~ ^-?[1-9][0-9]+$) ]]; then
        	return 0
        fi
        return 1
}

validate_input
if [[ "$?" == 0 ]]; then
	rev_number=$(echo "$number" | rev)
	digits=($(echo "$rev_number" | fold -w1 | tr '\n' ' '))
	count_digits="${#digits[@]}"
	if [[ "$#" -eq 1 ]]; then
		delimiter=" "
	fi
	new_number=""
	index=0
	for i in "${digits[@]}"; do
		if (( index % 3 == 0  && index != 0 ));then
			new_number+="$delimiter"
		fi
		new_number+="$i"
		(( ++index ))
	done
	echo "$new_number" | rev
else
	echo "$number is not an integer"
fi
