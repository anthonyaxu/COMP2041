#!/bin/sh

# qestion 6
acc_stdout="`cat acc_output.txt`"

echo "$acc_stdout" | egrep "[A-Z]{4}[0-9]{4}_" | cut -d':' -f 2 | tr ' ,' '\n' | egrep "_Student" | egrep -o "[A-Z]{4}[0-9]{4}"