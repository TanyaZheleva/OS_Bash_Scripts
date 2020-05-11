#!/bin/bash

uid=$1
username=$(egrep "^([^:]*:){2}$uid:" /etc/passwd | cut -d':' -f1)
found=""
until [[ "${found}" == "${username}" ]]; do
	echo "Waiting..."
	sleep 5
	found=$(w -h | awk '{print $1}' | grep "$username")
done


echo "$username logged in."
