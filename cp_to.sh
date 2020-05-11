#!/bin/bash

dir_from=$1
dir_to=$2

if [[ -d $dir_from ]]; then
	if [[ ! (-d $dir_to) ]]; then
		dir_to="$(date -I | tr '-' '_')"
		mkdir "${dir_to}"
		find "${dir_from}" -type f -cmin -45 -exec cp '{}' "${dir_to}" \;
		tar -cf "${dir_to}.tar" "$(basename ${dir_to})"
	fi
		find "${dir_from}" -type f -cmin -45 -exec cp '{}' "${dir_to}" \;
fi
