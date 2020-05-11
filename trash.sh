#!/bin/bash

if [ "${1}" == "-r" ]; then
        shift
        recursively="y" #can delete non-empty directories
else
        recursively="n"
fi

while [[ "$#" -gt 0 ]]; do
        name="${1}"
        if [ -f "${name}" ]; then
		date=$(date -Ins | cut -d"," -f1 | tr "T:" "-")
                new_name="${name}_${date}"
		mv "${name}" -t "${BACKUP_DIR}" #move the file to the backup folder
		mv "${BACKUP_DIR}${name}" "${BACKUP_DIR}${new_name}" #rename
		gzip -f "${BACKUP_DIR}${new_name}" #automatically deletes the original file
        elif [ -d "${name}" ]; then
                if [ "${recursively}" == "y" ];then
			date=$(date -Ins | cut -d"," -f1 | tr "T:" "-")
                        new_name="${BACKUP_DIR}${name}_${date}.tgz"
                        tar -czf "${new_name}" "${name}"
                        rm -r "${name}" 2>/dev/null
                else
                        count=$(find "${name}" -mindepth 1 2>/dev/null | wc -l ) #files in directory
                        if [ "${count}" -eq 0 ];then
				date=$(date -Ins | cut -d"," -f1 | tr "T:" "-")
		                new_name="${BACKUP_DIR}${name}_${date}.tgz"
				tar -czf "${new_name}" "${name}"
				rmdir "${name}" 
			else 
				echo "error: "${name}" is not empty, will not detele"
			fi
                fi

        fi
        shift
done

