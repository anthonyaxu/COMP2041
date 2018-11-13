#!/usr/bin/perl -w

use strict;

my $start = "$ARGV[0]";
my $end = "$ARGV[1]";
my $file = "$ARGV[2]";

open FILE, ">", $file or die;

while ($start <= $end) {
    print FILE "$start\n";
    $start++;
}
close FILE;
