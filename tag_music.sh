#!/bin/sh

for direc in "$@"
do
    if [ "$(ls -A "$direc")" ]
    then
        cd "$direc"
        for files in *
        do  
            split=`echo $files | sed 's/ - /}/g'`
        
            title=`echo $split | cut -d'}' -f 2 | sed -r 's/^ //' | sed -r 's/ $//'`
            artist=`echo $split | cut -d'}' -f 3 | sed -r 's/^ //' | sed -r 's/.mp3$//'` # | sed -r 's/ featuring [A-Za-z &]+//'` #tr -cd '\11\12\40-\176' | sed -r 's/ featuring [A-Za-z &]+//'`
            track=`echo $split | cut -d'}' -f 1 | sed -r 's/ $//'`
            album=`echo $direc | cut -d'/' -f 2`
            date=`echo $album | cut -d',' -f 2 | sed -r 's/^ //' | sed -r 's/ $//'`
            
            id3 -t "$title" "$files" > /dev/null 2>&1
            id3 -T "$track" "$files" > /dev/null 2>&1
            id3 -a "$artist" "$files" > /dev/null 2>&1
            id3 -A "$album" "$files" > /dev/null 2>&1
            id3 -y "$date" "$files" > /dev/null 2>&1
        done
    else
        continue
    fi
    cd - > /dev/null 2>&1
done
