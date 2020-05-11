#!/bin/bash

join -t',' -j1 <(sort -t',' -k1 city.csv) <(sort -t',' -k1 spread.csv) | awk -F ',' '$4>100 {printf "%s (%s): %d\n",$1,$2,($5/$4)*1000}' | sort -t':' -k2 -nr | head -n10


