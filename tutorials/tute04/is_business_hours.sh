#!/bin/sh

date_command="`date`"

current_time="`echo "$date_command" | egrep -o "[0-9]{2}:[0-9]{2}:[0-9]{2}" | cut -d':' -f 1`"
current_hour="`echo $current_time | cut -d':' -f 1`"
current_minute="`echo $current_time | cut -d':' -f 2`"

if test "$current_hour" -lt "9" -a "$current_hour" -le "16"
then
	exit 0
elif  test "$current_hour" -eq "17" -a "$current_minute" -eq "00"
then
	exit 0
else
	exit 1
fi