#!/bin/sh

# Testing functionality of 'rm' command

./legit.pl rm

./legit.pl init
./legit.pl rm

touch a b c d
./legit.pl add a b c d
./legit.pl commit -m "first commit"
./legit.pl rm nonexistent

rm a
./legit.pl add a
./legit.pl commit -m "removed a from index"
./legit.pl rm a

echo 123 >b
./legit.pl rm b
./legit.pl add b
./legit.pl rm b

echo qwerty >c
./legit.pl add c
echo asdf >c
./legit.pl rm c
./legit.pl rm --force --cached --cached c --force --cached b --force
./legit.pl rm --force --cached c b --cached --force
./legit.pl rm --force b

touch e
./legit.pl add e
./legit.pl rm e
./legit.pl rm --force e
