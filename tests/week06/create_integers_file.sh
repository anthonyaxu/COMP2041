#!/bin/sh

start="$1"
end="$2"
file="$3"

while test $start -le $end
do
    echo "$start" >> "$file"
    start=`expr $start + 1`
done
