#!/bin/sh 

first="$1"
second="$2"

if [ -z "$(ls -A $first)" ]
then
    if [ -z "$(ls -A $second)" ]
    then
        exit 0
    fi
fi

diff_files=`diff -q $first $second | egrep 'differ' | egrep -o ' [^ ]*/[^ ]* ' | sed 's/[^ ]*\///g' | sort | uniq`

#echo $diff_files

not_files=`diff -q $first $second | egrep '^Only in' | sed 's/^.*://g'`

#echo $not_files

arr=($diff_files $not_files)

#echo ${arr[@]}

#array=()
counter=0
cd $first
for fone in *
do
    counter=0
    for file in ${arr[@]}
    do 
        if test "$file" != "$fone"
        then
            counter=`expr $counter + 1`
        else
            break
        fi
    done
    if test $counter -eq ${#arr[@]}
    then
        echo "$fone"
        #array+=("$fone")
    fi
done

cd ..

#counter=0
#for file in ${array[@]}
#do
#    echo "$file"
#done
