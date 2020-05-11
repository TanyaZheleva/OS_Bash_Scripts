#!/bin/bash

check_if_exists(){
find ~ -type f -name "$1 2>/dev/null"
}

if [[ check_if_exists ]]; then
	pathname=$(find ~ -type f -name "$1" 2>/dev/null)
	grep -q "$2" "$pathname"
        echo "Exit status is: $?"

else
 echo "File doesn't exist." 2>&1	
 fi
