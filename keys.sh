#!/bin/bash

if [ "$#" -eq 3 -a -f "$1" ]; then
	t1=$(grep "$2" "$1" | cut -d "=" -f2-)
	t2=($(grep "$3" "$1" | cut -d "=" -f2-))
	new_t2=""
	length="${#t2[@]}"
	(( --length ))
	for i in "${!t2[@]}"; do
		if [[ "${t1}" =~ ' '*''${t2[$i]}' '*'' ]]; then
			continue
			echo "here"
		else
			new_t2+="${t2[$i]}"
			if [ "$i" -lt "${length}" ]; then
				new_t2+=" "
			fi
		fi
	done
	tempfile=$(mktemp ./temp_XXXX)	
	new_line+="$3=${new_t2}"

	while read line; do
		if [[ "$line" =~ "$3=" ]]; then
			echo "${new_line}" >> "${tempfile}"
		else
			echo "$line" >> "${tempfile}"
		fi
	done< <(cat $1)
	cat "${tempfile}" > "$1"
else
	exit 1
fi
