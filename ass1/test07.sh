#!/bin/sh

# Testing functionality of 'branch' command

./legit.pl branch

./legit.pl init
./legit.pl branch

touch a b
./legit.pl add a b
./legit.pl commit -m "first commit"

./legit.pl branch -invalid
./legit.pl branch -d "comp 2041"
./legit.pl branch ?invalid
./legit.pl branch .invalid
./legit.pl branch -d

./legit.pl branch testing
./legit.pl branch testing
./legit.pl branch

./legit.pl branch hyphen-branch
./legit.pl branch -d hyphen-branch testing
./legit.pl branch -d hyphen-branch -d testing
./legit.pl branch -d hyphen-branch -d -d -d -d
./legit.pl branch -d nonexistent
./legit.pl branch -d -d -d -d -d testing

./legit.pl branch branch
