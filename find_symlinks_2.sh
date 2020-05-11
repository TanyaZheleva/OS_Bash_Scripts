#!/bin/bash

if [ "$#" -eq 1 ];then
	if [ -d "$1" ]; then
		links=($(find "$1" -type l | tr '\n' ' '))
		for i in "${!links[@]}";do
			if [ -e "${links[$i]}" ]; then
				echo "${links[$i]}->$(readlink ${links[$i]})"	
			else
				(( ++broken ))
			fi
		done
		echo "The broken symlinks are ${broken}"
	else
		echo "$1 is not an existing directory" 2&>1
		exit 2
	fi
elif [ "$#" -eq 2 ]; then
	if [ -d "$1" ]; then
                links=($(find "$1" -type l | tr '\n' ' '))
                for i in "${!links[@]}";do
                        if [ -e "${links[$i]}" ]; then
                                echo "${links[$i]}->$(readlink ${links[$i]})" >> "$2"
                        else
                                (( ++broken ))
                        fi
                done
                echo "The broken symlinks are ${broken}" >> "$2"
        else
                echo "$1 is not an existing directory" 2&>1
                exit 2
        fi

else
	echo "invalid count of arguments" 2&>1
	exit 1
fi

