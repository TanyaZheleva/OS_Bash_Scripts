#!/bin/bash

sourcedir=$1
destination=$2
declare -A asociative_formats
if [[ -d "$sourcedir" && -d "$destination" ]]; then
	formats=($(find "$sourcedir" -not -type d -printf "%f\n" 2>/dev/null | egrep '^[^\.]+\.' | cut -d '.' -f2- | sort | uniq | tr '\n' ' ' )) #get all file formats once 
	#create subdirectories
	for i in "${formats[@]}";do
		mkdir "${destination}/${i}" 2>/dev/null
	done

	#move files to apropriate subdirectory by file format
	find "${sourcedir}" -not -type d  2>/dev/null | egrep '^[^\.]+\.' | while read name; do
		format_file=$(echo "${name}" | cut -d"." -f2-) #get format of file
		mv "${name}" "${destination}/${format_file}"
		#echo "name is $name and format is $format_file."
	done 
else
	echo "Invalid source or destination directory." 2&>1
	exit 1
fi

