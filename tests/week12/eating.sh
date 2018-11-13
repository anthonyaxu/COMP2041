#!/bin/sh

file="$1"

data=`cat $file`

echo "$data" | egrep "\"price\": " | cut -d',' -f'1' | sed "s/^ *{\"name\": \"//" | sed "s/\" *$//" | sort | uniq | sort
