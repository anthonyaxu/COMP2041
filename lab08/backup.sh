#!/bin/sh

file="$1"

number=0
while :
do
    if [ -f ".$file.$number" ]
    then
      number=`expr $number + 1`
    else
        cp "$file" ".$file.$number"
        echo "Backup of '"$file"' saved as '".$file.$number"'"
        break
    fi
done
