#!/bin/bash

join -t',' -j1 -o 1.2 2.3 2.4 <(sort -t',' -k1 city_province.csv) <(sort -t',' -k1 spread.csv) | sort -t ',' -k1 | awk -F ',' '{ registered[$1] += $2; deaths[$1] += $3 } END {for (i in registered) print i,registered[i],deaths[i]}' | awk ' $2>0 {printf "%s, %d\n",$1,($3/$2)*1000}' | sort -t',' -k1 | join -t',' -j1 -o 1.1 2.2 1.2 - <(sort -t',' -k1  province.csv) | awk -F',' '{print $1 " ("$2"): "$3}' | sort -t' ' -k3 -nr | head -n10

