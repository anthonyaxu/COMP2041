#!/bin/sh

# Testing functionality of 'checkout' command

./legit.pl checkout

./legit.pl init
./legit.pl checkout

touch a b
./legit.pl add a b
./legit.pl commit -m "first commit"

./legit.pl branch one
./legit.pl branch two
./legit.pl branch three four
./legit.pl checkout
./legit.pl checkout nonexistent
./legit.pl checkout -a one
./legit.pl checkout one checkout one
./legit.pl checkout one two

./legit.pl checkout one
./legit.pl checkout one

echo 1 >a
echo 2 >b
./legit.pl commit -a -m "second"
./legit.pl checkout master
./legit.pl show 0:a
./legit.pl show 1:a

echo 1.1 >>a
echo 3 >c
./legit.pl add a b c
./legit.pl commit -m "third"

./legit.pl checkout two
./legit.pl log

./legit.pl checkout one
./legit.pl log
./legit.pl checkout master
./legit.pl log
