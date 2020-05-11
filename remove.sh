#!/bin/bash

#every deleted file or directory is logged into the file ~/logs/remove.log and can be read from the environment variable RMLOG_FILE
touch ~/logs/remove.log

if [ "${1}" == "-r" ]; then 
	shift
	recursively="y" #can delete non-empty directories
else
	recursively="n"
fi

while [[ "$#" -gt 0 ]]; do
	name="${1}"
	if [ -f "${name}" ]; then
		rm "${name}"
		echo "[$(date -Ins | cut -d"," -f1 | tr "T" " ")] Removed file ${name}" >> ~/logs/remove.log
	elif [ -d "${name}" ]; then
		if [ "${recursively}" == "y" ];then
			find "${name}" -delete 2>/dev/null
			echo "[$(date -Ins | cut -d"," -f1 | tr "T" " ")] Removed directory recursively ${name}" >> ~/logs/remove.log
		else
			count=$(find "${name}" -mindepth 1 2>/dev/null | wc -l ) #files in directory
			if [ "${count}" -eq 0 ];then
				rmdir "${name}"
				echo "[$(date -Ins | cut -d"," -f1 | tr "T" " ")] Removed directory ${name}" >> ~/logs/remove.log
			fi
		fi

	fi	
	shift
done
