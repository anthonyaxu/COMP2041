#!/bin/sh

if test $# -eq 2
then
    if [[ $1 != [0-9]* ]]
    then
        echo "$0: argument 1 must be a non-negative integer"  
    elif test $1 -lt 0
    then
        echo "$0: argument 1 must be a non-negative integer"
    else
        n="$1"
        word="$2"
        counter=1
        while test $counter -le $n
        do
            echo $word
            counter=`expr $counter + 1`
        done
    fi
else
    echo "Usage: $0 <number of lines> <string>"
fi 
