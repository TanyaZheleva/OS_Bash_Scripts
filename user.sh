#!/bin/bash

read -p "Enter username of user on the system: " username

id -u $username >/dev/null

if [[ "$?" == 0 ]]; then
	sessions=$(w -h | cut -f1 -d " "| sort | uniq -c | grep "$username" | tr -s ' ' | cut -d ' ' -f2)
	echo "User ${username} has ${sessions} active sessions."
else
	echo "No user with such username on this system." 2&>1
fi
