#!/bin/bash

filename="$1" #file to add to
username="$2" #in to look for in /ets/passwd
nickname="$3" #the argument

if [[ -f "$filename" ]]; then
	matches=$(cut -d":" -f5 fake_passwd | grep -c "$username" -)	
	if [[ matches -gt 1 ]]; then
	usernames=($(egrep "([^:]*:){4}${username}:" fake_passwd | cut -d ":" -f1 | tr '\n' ' '))
	echo "0) exit"
	egrep "([^:]*:){4}${username}:" fake_passwd | cut -d ":" -f1 | nl -s ")" -v 1 -w1
	read -p "Enter 0 to exit or number >=1 to add: " number	
		if [[ number -eq 0 ]]; then
			echo "Program terminated."
			exit
		elif [[ number  -le ${#usernames[@]} ]]; then
			((--number))
			echo "${nickname}:${usernames[$number]}" >> "${filename}"
		else
			echo "Invalid entry."
			exit 1
		fi
	else
		name=$(egrep "([^:]*:){4}${username}:" fake_passwd | cut -d ":" -f1)
		echo "${nickname}:${name}" >> "${filename}"
	fi
else
	touch "${filename}"
	name=$(egrep "([^:]*:){4}${username}:" fake_passwd | cut -d ":" -f1)
	echo "${nickname}:${name}" >> "${filename}"
fi
