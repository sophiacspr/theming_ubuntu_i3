#!/bin/bash

# read temperature
temp=$(sensors 2>/dev/null | awk '/^Package id 0:/ {print $4; exit}') # get the text of the 4th whitespace separated chunk of that line of text that is the temperature reading

# if no temp, add N/A
if [ -z "$temp" ]; then
    temp="N/A"
fi

# output temperature
echo "${temp}"
