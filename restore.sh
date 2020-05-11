#!/bin/bash

decompress_file(){
	name="$1"
        if [ "$#" -eq 2 ]; then
                path="$2"
        else
        	path=$(pwd)
        fi
	files=($(find "$BACKUP_DIR" -type f -name "${name}*"))
	filesListing=($(find "$BACKUP_DIR" -type f -name "${name}*" -printf "%f\n" | sed 's/^\([[:alnum:]]*\)\(_\)\([[:digit:]]*\)\(-\)\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\(.*\)$/\1\t(\3\/\5\/\6 \7:\8:\9)/g'))
	if [ "${files}" -gt 1 ]; then
		echo "0) exit"
		echo "${filesListing}" | grep ".*" | nl -s ")" -v 1 -w1
		read -p "Enter 0 to exit or number >=1 to add: " number
                if [[ number -eq 0 ]]; then
                        echo "Program terminated."
                        exit
                elif [[ number  -le ${#files[@]} ]]; then
                        ((--number))
                	new_name="${path}${name}.gz"
			mv "${files[$number]}" "${new_name}"
                	gunzip "${new_name}"
		else
                        echo "Invalid entry."
                        exit 1
                fi

	else
        	backup_name=$(find "$BACKUP_DIR" -type f -name "${name}*")
	        new_name="${path}${name}.gz"
	        mv "${backup_name}" "${new_name}"
	        gunzip "${new_name}"
	fi
}
 
decompress_directory(){
	name="$1"
        if [ "$#" -eq 2 ]; then
		path="$2"
	else
	path=$(pwd)
	fi
	directories=($(find "$BACKUP_DIR" -type f -name "${name}*"))
        dirsListing=($(find "$BACKUP_DIR" -type f -name "${name}*" -printf "%f\n" | sed 's/^\([[:alnum:]]*\)\(_\)\([[:digit:]]*\)\(-\)\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\(.*\)$/\1\t(\3\/\5\/\6 \7:\8:\9)/g'))
        if [ "${directories}" -gt 1 ]; then
                echo "0) exit"
                echo "${dirsListing}" | grep ".*" | nl -s ")" -v 1 -w1
                read -p "Enter 0 to exit or number >=1 to add: " number
                if [[ number -eq 0 ]]; then
                        echo "Program terminated."
                        exit
                elif [[ number  -le ${#directories[@]} ]]; then
                        ((--number))
                        new_name="${path}${name}.gz"
                        mv "${files[$number]}" "${new_name}"
                        tar -xf "${new_name}"
                	rm "${new_name}"
                else
                        echo "Invalid entry."
                        exit 1
                fi

        else
        	backup_name=$(find "$BACKUP_DIR" -name "${name}*.tgz")
        	new_name="${path}${name}.tgz"
        	mv "${backup_name}" "${new_name}"
        	tar -xf "${new_name}"
        	rm "${new_name}"
	fi
}

if [ "$1" == "-l" ]; then
        find "$BACKUP_DIR" -type f -printf "%f\n" | sed 's/^\([[:alnum:]]*\)\(_\)\([[:digit:]]*\)\(-\)\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\4\([[:digit:]]*\)\(.*\)$/\1\t(\3\/\5\/\6 \7:\8:\9)/g'
fi


if [ "$#" -eq 1 ]; then
	if [ -f "$1" ]; then
		decompress_file "$1"
	elif [ -d "$1" ]; then
		decompress_directory "$1"
	fi
elif [ "$#" -eq 2 ]; then
	dest="$2"
	 if [ -f "$1" ]; then
                decompress_file "$1" "$dest"
        elif [ -d "$1" ]; then
                decompress_directory "$1" "$dest"
        fi
fi
