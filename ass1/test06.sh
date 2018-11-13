#!/bin/sh

# Testing the functionality of the 'status' command

./legit.pl status

./legit.pl init
./legit.pl status

touch a b c d e f g h
./legit.pl add a b c d e f g
./legit.pl commit -m "first"

echo 1 >a
echo 2 >b
echo 3 >c

./legit.pl add a b
echo 1.1 >>a
./legit.pl rm d
rm e
./legit.pl rm --cached f
./legit.pl status
