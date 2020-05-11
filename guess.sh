#!/bin/bash

left=$1
right=$2
if [[ "${left}" -le "${right}" ]]; then
	value=$(( (RANDOM % right) + left ))
fi

read -p "Guess??" guessed_value
count=1
until [[ "${guessed_value}" -eq "${value}" ]]; do
	 if [[ ("$guessed_value" =~ ^0$ ) || ("$guessed_value" =~ ^-?[1-9]$) || ("$guessed_value" =~ ^-?[1-9][0-9]+$) ]];then
		if [[ "${guessed_value}" -lt "${value}" ]]; then
			echo "...bigger!"
		else
			echo "...smaller!"
		fi
	else
		echo "Invalid entry."
	fi
	read -p "Guess??" guessed_value
	(( ++count ))
done

echo "RIGHT! Guessed ${value}  in ${count} tries!"
