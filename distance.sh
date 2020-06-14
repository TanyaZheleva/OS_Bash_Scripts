#!/bin/bash

filename=$1
subcommand=$2
callsign1=$3
callsign2=$4
RADIUS=6371
find_line(){
	filename=$1
	callsign=$2
line=$(grep -m1 "=$callsign[ ;[(]" "${filename}")
        if [[ -n "${line}" ]]; then
                echo "$line"
        else
                tempfile1=$(mktemp /tmp/tempcalls1.XXXX)
                tempfile2=$(mktemp /tmp/tempcalls2.XXXX)
                cut -d "," -f 10 "$filename" | sed "s/;"$"//g" | tr " " "\n" >"${tempfile1}"
                length="${#callsign}"
                (( ++ length ))
                matches="2" #count lines after each grep; if 1 then we have the longest possible match in that temporary file
                i=1 #count letters from callsign used
                until [[ ("${matches}" -le 1) ]]; do
                        if [ $(( i%2 )) -eq 1 ] ; then
                                grep "^${callsign:0:${i}}" "${tempfile1}" >"${tempfile2}"
                                matches=$(wc -l "${tempfile2}" | cut -d" " -f 1)
                        else
                                grep "^${callsign:0:${i}}" "${tempfile2}" >"${tempfile1}"
                                matches=$(wc -l "${tempfile1}" | cut -d" " -f 1)
                        fi
                        if [ "${matches}" -gt 0 ]; then
                                (( ++i ))
                        fi
                        if [ "${i}" -gt "${length}" ]; then
                                break
                        fi
                done
                (( --i ))
                pattern="${callsign:0:${i}}"
                line=$(grep -m1 "[ ,]${pattern}[ ;[(]" "${filename}")

                echo "$line"
		rm "${tempfile1}"
		rm "${tempfile2}"
	fi
}

#about distance
line1=$(find_line "${filename}" "${callsign1}")
line2=$(find_line "${filename}" "${callsign2}")

#get longtitudes and latitudes
longtitude1=$(echo "${line1}" | cut -d "," -f 8)
longtitude2=$(echo "${line2}" | cut -d "," -f 8)
latitude1=$(echo "${line1}" | cut -d "," -f 7)
latitude2=$(echo "${line2}" | cut -d "," -f 7)

sin(){
    echo "s($1*0.017453293)" | bc -l
}
cos(){
    echo "c($1*0.017453293)" | bc -l
}
diff(){ 
    if (( $(echo "$1 < 0" | bc -l) && $(echo "$2 < 0" | bc -l) ));then
	    if (($(echo "$1 < $2" | bc -l) )); then
		    difference=$(echo "$2 - $1" | bc -l)
		    echo "${difference}"
           else 
		   difference=$(echo "$1 - $2" | bc -l)
                   echo "${difference}"
	    fi
    elif (( $(echo "$1 > 0" | bc -l) && $(echo "$2 > 0" | bc -l) ));then
            if (($(echo "$1 < $2" | bc -l) )); then
            	difference=$(echo "$2 - $1" | bc -l)
            	echo "${difference}"
	    else
            	difference=$(echo "$1 - $2" | bc -l)
                echo "${difference}"
            fi
    else
	    left="$1"
	    right="$2"
	    if (($(echo "$1 < 0" | bc -l) )); then
	    	left=$(echo "$1 * -1" | bc)
    	    fi
	    if (($(echo "$2 < 0" | bc -l) )); then
	    	right=$(echo "$2 * -1" | bc)
            fi
	    difference=$(echo "$right + $left" | bc -l)
            echo "${difference}"
    fi
}
arccos(){
    if (( $(echo "$1 == 0" | bc -l) )); then
        echo "a(1)*2" | bc -l
    elif (( $(echo "(-1 <= $1) && ($1 < 0)" | bc -l) )); then
        echo "a(1)*4 - a(sqrt((1/($1^2))-1))" | bc -l
    elif (( $(echo "(0 < $1) && ($1 <= 1)" | bc -l) )); then
        echo "a(sqrt((1/($1^2))-1))" | bc -l
    else
        echo "input out of range" 2&>1
        return 1
    fi
}

sin1=$(sin "${latitude1}")
sin2=$(sin "${latitude2}")
cos1=$(cos "${latitude1}")
cos2=$(cos "${latitude2}")
dist=$(diff "${longtitude1}" "${longtitude2}")
cos3=$(cos "${dist}")
sum=$( echo "${sin1} * ${sin2} + ${cos1} * ${cos2} * ${cos3}" | bc -l )
acos=$(arccos "${sum}")
result=$(echo "${acos} * ${RADIUS}" | bc -l )
integer_part=$( echo "${result}" | cut -d "." -f 1)
decimal_part=$( echo "${result}" | cut -d "." -f 2)
if [[ "${decimal_part}" =~ ^[56789][0-9]*$ ]];then
	(( ++integer_part))
fi
echo "$integer_part"
