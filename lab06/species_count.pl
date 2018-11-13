#!/usr/bin/perl -w

use strict;

my $species = "$ARGV[0]";
my $file = "$ARGV[1]";

open FILE, "<", $file or die "$0: can't open $file";
my @contents = <FILE>;
my $total_lines = $#contents + 1;
my $counter = 0;
my $index = 0;
my @matches;
while ($counter < $total_lines) {
    if ($contents[$counter] =~ /$species/) {
        $matches[$index] = $contents[$counter];
        $index++;
    }
    $counter++;
}

my $pods = $#matches + 1;

my $size = $pods;
$counter = 0;
my $sum = 0;
while ($counter < $size) {
    $matches[$counter] =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2} //;
    $matches[$counter] =~ s/ $species$//;
    $sum += $matches[$counter];
    $counter++;
}
close FILE;
print "$species observations: $pods pods, $sum individuals\n";
