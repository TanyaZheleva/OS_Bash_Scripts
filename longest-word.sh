#!/bin/bash

#longest-word: find longest string in a file

for i; do
	if [[ -r "$i" ]]; then
		max_word=
		max_length=0
		for j in $(strings $i); do
			length="${#j}"
			if (( length > max_length )); then
				max_word="$j"
				max_length="$length"
			fi
		done
		echo "$i: '$max_word' ($max_length characters)"
	fi
done

