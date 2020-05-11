#!/bin/bash
grep ',Wuhan$' city.csv | cut -d ',' -f1 | grep -f - spread.csv | cut -d ',' -f4
