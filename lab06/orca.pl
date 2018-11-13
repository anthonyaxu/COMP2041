#!/usr/bin/perl -w

use strict;

my $input = "$ARGV[0]"; 

open FILE, "<", $input or die "$0: can't open $input";
my @contents = <FILE>;
my $total_lines = $#contents + 1;
my $counter = 0;
my $index = 0;
my @matches;
while ($counter < $total_lines) {
    if ($contents[$counter] =~ /Orca/) {
        $matches[$index] = $contents[$counter];
        $index++;
    }
    $counter++;
}

my $size = $#matches + 1;
$counter = 0;
my $sum = 0;
while ($counter < $size) {
    $matches[$counter] =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2} //;
    $matches[$counter] =~ s/ Orca$//;
    $sum += $matches[$counter];
    $counter++;
}
close FILE;
print "$sum Orcas reported in $input\n";
