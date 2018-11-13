#!/bin/sh

# Testing most of the functionality of the 'commit' command

./legit.pl init
echo Line 1 >a
echo Hello World! >b
echo First >c

# Testing error and usage messages of 'commit'
./legit.pl commit
./legit.pl commit "some message"
./legit.pl commit -m "message1" "message2"
./legit.pl commit -m
./legit.pl commit -m ""
./legit.pl commit -m "nothing in index"

./legit.pl add a b
./legit.pl commit -m "first commit"

./legit.pl add a b
./legit.pl commit -m "files in index unchanged"

echo Line 2 >>a
./legit.pl add a b
./legit.pl commit -m "added line to a"

echo Hi World! >>b
./legit.pl commit -m "changed b but not in index"
./legit.pl add a b
./legit.pl commit -m "added line to b"

./legit.pl add c
./legit.pl commit -m "message not recorded" -m "this message is recorded"
