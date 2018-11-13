#!/bin/sh

getDate="`date`"
time="`echo "$getDate" | egrep -o "[0-9]{2}:[0-9]{2}"`"
month="`echo "$getDate" | cut -d' ' -f 3 `"
date="`echo "$getDate" | cut -d' ' -f 2 `"

for image in "$@"
do
    convert -gravity south -pointsize 36 -draw "text 0,10'$month $date $time'" "$image" temporary_file.jpg
    display temporary_file.jpg
    rm temporary_file.jpg
done
