#!/bin/sh

for file in "$@"
do
    while read -r "line"
    do
        check=`echo "$line" | egrep '^#include "[A-Za-z0-9]*.h"$' | cut -d'"' -f2`
        if test "$check" != ""
        then
            if [ -f "$check" ]
            then
                continue
            else
                echo ""$check" included into "$file" does not exist"  
            fi
        fi
    done < "$file"
done
