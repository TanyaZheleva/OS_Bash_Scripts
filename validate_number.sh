#!/bin/bash

number=$1
left=$2
right=$3

validate_input(){
	if [[ ("$number" =~ ^0$ ) || ("$number" =~ ^-?[1-9]$) || ("$number" =~ ^-?[1-9][0-9]+$) ]];then
		 if [[ ("$left" =~ ^0$ ) || ("$left" =~ ^-?[1-9]$) || ("$left" =~ ^-?[1-9][0-9]+$) ]];then
			  if [[ ("$right" =~ ^0$ ) || ("$right" =~ ^-?[1-9]$) || ("$right" =~ ^-?[1-9][0-9]+$) ]];then
				  return 0
			  fi
		  fi
	  fi
	  return 1
}

validate_input

if [[ "$?"  == 0 ]]; then
	if [[ "$left" -le "$right" ]]; then
		if [[ "$number" -ge "$left" && "$number" -le "$right" ]]; then
			exit 0
		else
			exit 1
		fi
	else
		exit 2
	fi

else
	exit 3
fi
