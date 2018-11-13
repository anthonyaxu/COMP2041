#~/bin/sh

mlalias_stdout="`cat COMP2041-list`"

echo "$mlalias_stdout" | egrep -v ":"