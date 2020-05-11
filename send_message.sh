#!/bin/bash

user="$1"
address_book="/home/tanya/my_addr_book"

username=$(grep "$user" "$address_book" | cut -d " " -f 2)

while [ IFS=='$\n' ]; do
	write $username 
       	read -r line
done
