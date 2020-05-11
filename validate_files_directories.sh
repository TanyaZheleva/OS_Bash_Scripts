#!/bin/bash

#Да се напише shell скрипт, който приема произволен брой аргументи - имена на файлове или директории. Скриптът да извежда за всеки аргумент подходящо съобщение:
#	- дали е файл, който може да прочетем
#	- ако е директория - имената на файловете в нея, които имат размер, по-малък от броя на файловете в директорията.


while [[ "$#" -gt 0 ]]; do
	if [[ -f "$1" ]]; then
		[[ -r "$1" ]] && echo "$1 is a readable file." || echo "$1 is not a readable file." 
	elif [[ -d "$1" ]]; then
		echo "$1 is a directory and these are the files, which are smaller than the count of files in total(in the directory):"
		count_files=$(find "$1" -type f 2>/dev/null| wc -l)
		find "$1" -type f -size -"$count_files"c 2>/dev/null
	fi
	shift
done
