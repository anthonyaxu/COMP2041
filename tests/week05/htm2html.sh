#!/bin/sh

for file in *.htm*
do
    name=`echo "$file" | sed -r "s/.htm(l)?$//"`
    if [[ -f "$name.html" ]]
    then
        if [[ -f "$name.htm" ]]
        then
            echo "$name.html exists"
            exit 1
        fi
    fi
    
    if test "$name.htm" = "$file"
    then
        mv "$file" "$name.html"
    fi
done
