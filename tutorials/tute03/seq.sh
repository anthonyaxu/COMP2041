#!/bin/sh

if test $# -eq 1
then
	begin=1
	seq_counter=$begin
	end="$1"
	while test $seq_counter -le $end
	do
		echo $seq_counter
		seq_counter=`expr $seq_counter + 1`
	done
elif test $# -eq 2
then
	begin="$1"
	seq_counter=$begin
	end="$2"
	while test $seq_counter -le $end
	do
		echo $seq_counter
		seq_counter=`expr $seq_counter + 1`
	done
elif test $# -eq 3
then
	begin="$1"
	seq_counter=$begin
	incrementor="$2"
	end="$3"
	while test $seq_counter -le $end
	do
		echo $seq_counter
		seq_counter=`expr $seq_counter + incrementor`
	done
else
	echo "$0 : Invalid amount of arguments"
fi