#!/bin/sh

small="Small files:"
medium="Medium-sized files:"
large="Large files:"
for file in *
do
    num=`wc -l < $file`
    if test $((num)) -lt 10
    then
        small="$small $file"
    elif test $((num)) -ge 10 && test $((num)) -lt 100
    then
        medium="$medium $file"
    else
        large="$large $file"
    fi
done
echo $small
echo $medium
echo $large
