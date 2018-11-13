#!/usr/bin/perl -w

open FILE1, "<", $ARGV[0] or die "Cannot open $ARGV[0]\n";
# reading a line from FILE1 which goes into the default variable
# and puts it into the hash (which becomes the key) then increments the key value
$words{$_} ++ while (<FILE1>);
close FILE1;

open FILE2, "<", $ARGV[1] or die "Cannot open $ARGV[1]\n";
# "delete" deletes the key value pair
delete $words{$_} while (<FILE2>);
close FILE2;

print sort keys %words;