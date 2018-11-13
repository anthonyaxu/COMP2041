#!/bin/sh

for file in *
do
    name=`echo $file | sed -r 's/.[a-z]{2,3}$//'`
    if test "$name.jpg" = "$file" -o "$name.png" = "$file"
    then
        if test -f "$name.png"
        then
            echo "$name.png already exists"
            exit 1
        else
            convert "$file" "$name.png"
            rm "$file"
        fi
    fi
done
