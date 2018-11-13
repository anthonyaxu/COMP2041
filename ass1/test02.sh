#!/bin/sh

# Testing functionality of 'log' command

./legit.pl init

./legit.pl log

touch a b c d e f
./legit.pl add a b
./legit.pl commit -m "first commit"
./legit.pl add d
./legit.pl commit -m "isn't recorded" -m "second commit"

./legit.pl log

./legit.pl add d
./legit.pl commit -m "nothing changed"

./legit.pl log

./legit.pl add a b e f
./legit.pl commit -m "third commit"

./legit.pl log
