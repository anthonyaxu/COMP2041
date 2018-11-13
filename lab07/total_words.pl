#!/usr/bin/perl -w

use strict;

my %word_count = ();

while (my $line = <STDIN>) {
    $line =~ tr/A-Z/a-z/;
    foreach my $word ($line =~ /[a-z]+/g) {
        $word_count{$word}++;
    }
}

my $total = 0;
foreach my $word (keys %word_count) {
    $total += $word_count{$word};
}

print "$total words\n";
