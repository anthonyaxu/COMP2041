#!/bin/sh

cat courses.txt | sed -r "s/COMP([29]04)1/\12/g"