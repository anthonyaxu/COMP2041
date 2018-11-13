#!/usr/bin/perl -w

use strict;

my $line = "$ARGV[0]";
my $file = "$ARGV[1]";

open FILE, "<", $file or die "$0: can't open $file\n"; 

my @contents = <FILE>;
my $total_lines = $#contents + 1;

if ($line > $total_lines) {
    close FILE;
    exit 1;
}

print "$contents[$line-1]";

close FILE;
