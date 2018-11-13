#!/bin/sh

./legit.pl init

# ".legit/" is the directory that is made when the git is initialised
if test -e .legit/
then
	echo "success"
else
	echo "fail"
fi