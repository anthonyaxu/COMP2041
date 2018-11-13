#!/bin/sh

file="$1"
name=`egrep "^COMP[29]041" "$file" | cut -d'|' -f3 | cut -d',' -f2 | sed "s/^ //" | cut -d' ' -f1 | sort | uniq -c | sort | tail -1 | sed "s/^[ ]*[0-9*] //"`
echo $name
