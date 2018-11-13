#!/bin/sh

# Testing some functionality of 'merge' command 

./legit.pl merge

./legit.pl init
./legit.pl merge

seq 1 4 >end_space
./legit.pl add end_space
./legit.pl commit -m first
./legit.pl branch one
./legit.pl checkout one

perl -pi -e 's/2/100      /' end_space
./legit.pl commit -a -m second
./legit.pl checkout master

perl -pi -e 's/2/100/' end_space
./legit.pl commit -a -m third
./legit.pl merge one -m merge
