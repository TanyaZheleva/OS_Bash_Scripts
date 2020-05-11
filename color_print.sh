#!/bin/bash

if [ "$#" -eq 2 ];then
	colour="$1"
	string="$2"
	case "${colour}" in
		-r) echo -e "\033[0;31m ${string}\033[0m"
			exit 
			;;
		-g) echo -e "\033[0;32m ${string}\033[0m"
                        exit
                        ;;
		-b) echo -e "\033[0;34m ${string}\033[0m"
                        exit
                        ;;
		*) echo "Unknown colour."
			exit 1 
			;;
	esac
else
	echo "${1}"
fi
