#!/bin/bash

username=$1


count_processes=$(ps rhU "$username" | wc -l)
pids=($(ps U "$username" o "%p" rh | tr '\n' ' '))
for i in "${pids[@]}"; do
	kill "$i" 2>/dev/null
done
echo "count processes is $count_processes"


