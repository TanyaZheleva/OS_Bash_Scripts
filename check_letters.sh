#!/bin/bash

read parameter

if [[ "$parameter" =~ ^[[:alnum:]]+$ ]]; then
	echo "The parameter consists of numbers and letters only."
else
	echo "The parameter doesn't consist of numbers and letters only." 2>&1
	exit 1
fi
	
