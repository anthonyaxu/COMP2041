#!/usr/bin/perl -w

use strict;

my %word_count = ();

my $find = "$ARGV[0]";

while (my $line = <STDIN>) {
    $line =~ tr/A-Z/a-z/;
    foreach my $word ($line =~ /[a-z]+/g) {
        $word_count{$word}++;
    }
}

if (exists $word_count{$find}) {
    print "$find occurred $word_count{$find} times\n";
} else {
    print "$find occurred 0 times\n";
}
