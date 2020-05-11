#!/bin/bash

colour=${1}
iteration=1
if [[ "${colour}" == "-r" ]]; then
	iteration=1
elif [[ "${colour}" == "-g" ]]; then
	iteration=2
elif [[ "${colour}" == "-b" ]]; then
        iteration=3
fi

cat | while read string; do
	if [[ "${colour}" == "-x" ]]; then
		echo "${string}"
	elif [[ "${iteration}" == "1" ]]; then
		echo -e "\033[0;31m${string}\033[0m"
		iteration=2
	 elif [[ "${iteration}" == "2" ]]; then
                echo -e "\033[0;32m${string}\033[0m"
                iteration=3
	 elif [[ "${iteration}" == "3" ]]; then
                echo -e "\033[0;34m${string}\033[0m"
                iteration=1
	fi

done


