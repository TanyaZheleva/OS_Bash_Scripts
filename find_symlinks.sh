#!/bin/bash

if [ "$#" -eq 1 && -d "$1" ]; then
	find "$1" - type l 
else
	exit 1
fi
