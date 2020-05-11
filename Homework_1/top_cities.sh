#!/bin/bash

awk -F ',' '$3>=101 {printf "%s: %d\n",$1,($4/$3)*1000}' spread.csv | sort -t ':' -k 2 -nr | head -n10
