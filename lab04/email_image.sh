#!/bin/sh

for image in "$@"
do
    display "$image"
    echo -n "Address to e-mail this image to? "
    read email

    echo -n "Message to accompany image? "
    read message

    echo "$message" | mutt -s "$message" -e "set copy=no" -a "$image" -- $email
done
