#!/bin/bash

while read length name ; do
	echo "length is $length"
	echo "name is $name"
	echo " "
done< <(find . -type f -exec wc -l '{}' \;)

