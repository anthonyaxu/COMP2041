#!/bin/sh

i=1
while read text
do
    line=`echo $text | tr '0-4' '<' | tr '6-9' '>'`
    if test $i -eq 1
    then
        final=$line
        i=`expr $i + 1`
    else
        final="$final\n$line"
    fi
done
echo -e $final
