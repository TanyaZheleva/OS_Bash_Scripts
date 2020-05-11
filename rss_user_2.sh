#!/bin/bash

 if [ "$EUID" -eq 0 ]; then
        tempfile1=$(mktemp ./temp.XXX)
        tempfile2=$(mktemp ./temp.XXX)
        ps -e -o uid= -o pid= -o  rss= | sort -t " " -k1 -n | tr -s " " > "${tempfile1}"
	
        awk '{sum_rss[$1]+=$3; count_rss[$1]+=1} END {for (i in sum_rss) printf "%d %d %d\n",i,sum_rss[i],sum_rss[i]/count_rss[i] }' "${tempfile1}" > "${tempfile2}"
	cat "${tempfile2}" | cut -d " " -f 1,2

        cat "${tempfile2}" | while read id val number; do

        	if [ "${val}" -gt "${number}" ]; then
                	egrep "^[ ]*${id} " "${tempfile1}" | sort -t " " -k4 -nr | head -n1 |awk '{print $2}' | xargs kill -9
                     
		fi
        done
	rm "${tempfile1}"
	rm "${tempfile2}"
fi

