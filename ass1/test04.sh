#!/bin/sh

# Testing functionality of 'commit' command with the '-a' flag

./legit.pl init
echo 1 >a
echo 2 >b
echo 3 >c
echo 4 >d

./legit.pl add a b c d
./legit.pl commit -m "random message" -m "added all files to index"
./legit.pl commit -a -m "no changes"

./legit.pl show 0:a
./legit.pl show 0:b
./legit.pl show :a
./legit.pl show :b

echo 1.1 >>a
echo 3.1 >>c

./legit.pl commit -a -m "changed a and c" -a -a -a
./legit.pl show :a
./legit.pl show 1:a
./legit.pl show :b

./legit.pl commit -m -a "invalid commit"
echo 4.1 >>d
./legit.pl commit -a -a -a -m "changed d" -a -a -a -a
