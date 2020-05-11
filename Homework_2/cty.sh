#!/bin/bash

validate_filename(){
	if [ -f "$1" ]; then
		return 0
	else
		return 1
	fi
}

validate_callsign(){
	if [[ "$1" =~ ^([A-Z]*[0-9]*/*)*$ ]]; then
                return 0
	else
		return 1
        fi
}

find_pattern(){
	local filename=$1
        local callsign=$2
	local  tempfile1=$(mktemp /tmp/tempcalls1.XXXX)
        local  tempfile2=$(mktemp /tmp/tempcalls2.XXXX)
        cut -d "," -f 10 "${filename}" | sed "s/;"$"//g" | tr " " "\n" >"${tempfile1}"
        local length="${#callsign}"
        (( ++ length ))
        local matches="2" #count lines after each grep; if 1 then we have the longest possible match in that temporary file
        local i=1 #count letters from callsign used
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
        local pattern="${callsign:0:${i}}"
	echo "$pattern"
	rm "${tempfile1}"
	rm "${tempfile2}"
}

find_line(){
	local filename=$1
	local callsign=$2
	local line=$(grep -m1 "=$callsign[ ;[(]" "${filename}")
        if [[ -n "${line}" ]]; then
                echo "$line"
        else
		local pattern=$(find_pattern "${filename}" "${callsign}")
                local line=$(grep -m1 "[ ,]${pattern}[ ;[(]" "${filename}")
                echo "$line"
	fi
}
	
sin(){
    echo "s($1*0.017453293)" | bc -l
}

cos(){
    echo "c($1*0.017453293)" | bc -l
}

diff(){
    if (( $(echo "$1 < 0" | bc -l) && $(echo "$2 < 0" | bc -l) ));then
	    if (($(echo "$1 < $2" | bc -l) )); then
		    local difference=$(echo "$2 - $1" | bc -l)
		    echo "${difference}"
           else
		   local difference=$(echo "$1 - $2" | bc -l)
                   echo "${difference}"
	    fi
    elif (( $(echo "$1 > 0" | bc -l) && $(echo "$2 > 0" | bc -l) ));then
            if (($(echo "$1 < $2" | bc -l) )); then
            	local difference=$(echo "$2 - $1" | bc -l)
            	echo "${difference}"
	    else
            	local difference=$(echo "$1 - $2" | bc -l)
                echo "${difference}"
            fi
    else
	    local left="$1"
	    local right="$2"
	    if (($(echo "$1 < 0" | bc -l) )); then
	    	left=$(echo "$1 * -1" | bc)
    	    fi
	    if (($(echo "$2 < 0" | bc -l) )); then
	    	right=$(echo "$2 * -1" | bc)
            fi
	    local difference=$(echo "$right + $left" | bc -l)
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

#subcommands country and zones
if [ "$#" -eq 3 ]; then
	filename=$1
	if !(validate_filename "${filename}") ; then
		echo "Invalid filename\n" 2>&1
		exit 1
	fi
	#check if file in filename is apropriate .csv format 
	subcommand=$2
	if [ "${subcommand}" != "country" -a "${subcommand}" != "zones" ]; then
		echo "Invalid subcommand\n" 2&>1
		exit 1
	fi
	callsign=$3
	if !(validate_callsign "${callsign}") ; then
		echo "Invalid callsign\n" 2&>1
		exit 1
	fi	
	line=$(find_line "${filename}" "${callsign}")
	if [[ -n "${line}" ]]; then
		if [ "${subcommand}" == "country" ]; then
                        country=$(echo "${line}" | cut -d "," -f 2)
                        echo "${country}"
                elif [ "${subcommand}" == "zones" ]; then
			tempzones=$(mktemp /tmp/tempzones.XXXX)
			echo "${line}" | cut -d"," -f 10 | tr " " "\n" > "${tempzones}"
			current=$(grep -m1 "^=$callsign[ ;[(]" "${tempzones}")
			if [[ -z "${current}" ]]; then
				pattern=$(find_pattern "${filename}" "${callsign}")
				current=$(grep -m1 "^$pattern[ ;[(]" "${tempzones}")
			fi
			itu=$(echo "${current}" | grep -o "\[[[:digit:]]*\]"| grep -o "[[:digit:]]*")
			waz=$(echo "${current}" | grep -o "([[:digit:]]*)"| grep -o "[[:digit:]]*")
			if [ -z "${itu}" ]; then
				itu=$(echo "${line}" | awk -F "," '{print $6}')
			fi
			if [ -z "${waz}" ]; then
                                waz=$(echo "${line}" | awk -F "," '{print $5}')
			fi
			echo "${itu} ${waz}"
			rm "${tempzones}"
                fi
	else
		echo "no matches\n" 2&>1
		exit 1
	fi

#subcommand distance
elif [ "$#" -eq 4 ]; then
        filename=$1
	if !(validate_filename "${filename}") ; then
                echo "Invalid filename\n" 2&>1
                exit 1
        fi
        subcommand=$2
	if [ "${subcommand}" != "distance" ]; then
		echo "Invalid subcommand\n" 2&>1
		exit 1
	fi
        callsign1=$3
	callsign2=$4
	RADIUS=6371 #radius
	if !(validate_callsign "${callsign1}" && validate_callsign "${callsign2}") ; then
               echo "invalid callsigns\n" 2&>1
               exit 1
        fi
	line1=$(find_line "${filename}" "${callsign1}")
	line2=$(find_line "${filename}" "${callsign2}")
	if [[ -n "${line1}" && -n "${line2}" ]]; then
#get longtitudes and latitudes
		longtitude1=$(echo "${line1}" | cut -d "," -f 8)
		longtitude2=$(echo "${line2}" | cut -d "," -f 8)
		latitude1=$(echo "${line1}" | cut -d "," -f 7)
		latitude2=$(echo "${line2}" | cut -d "," -f 7)
#calculate distance
#formula: distance=arccos(sin(latitude1)*sin(latitude2)+cos(latitude1)*cos(latitude2)*cos(|longtitude1 - longtitude2|))*radius
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
#rounding up to an integer
		if [[ "${decimal_part}" =~ ^[56789][0-9]*$ ]];then
			(( ++integer_part))
		fi
		echo "$integer_part"
	else
		echo "no matches\n" 2&>1
                exit 1
        fi
fi

