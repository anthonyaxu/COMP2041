#!/usr/bin/perl -w

use strict;

my @contents;
while (my $line = <STDIN>) {
    push @contents, $line;
}

my $counter = 0;
my $size = $#contents;
while ($counter < $size) {
    $size = $#contents;
    my $num = rand($size);
    print "$contents[$num]";
    $num = substr($num, 0, index($num, '.'));
    splice @contents, $num, 1;
}
