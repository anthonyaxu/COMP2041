#!/bin/sh

# Testing functionality of 'show' command

./legit.pl init

./legit.pl show

echo Line 1 >a
echo Hello World! >b
echo First >c

./legit.pl add a b
./legit.pl commit -m "first commit"

./legit.pl show 0:a
./legit.pl show 0:b
./legit.pl show 0:c

./legit.pl show :a
./legit.pl show :b
./legit.pl show :c

./legit.pl show 1:a
./legit.pl show -invalidname:a
./legit.pl show 0:-nonexistent

echo Line 2 >>a
./legit.pl add a c
./legit.pl show :a
./legit.pl show :c
./legit.pl commit -m "second commit"
./legit.pl show 1:a
./legit.pl show 1:b
./legit.pl show 1:c
./legit.pl show 0:c
