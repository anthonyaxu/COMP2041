#!/usr/bin/perl -w

use strict;

my $find = "$ARGV[0]";

foreach my $file (glob "lyrics/*.txt") {
    my %word_count = ();
    
    open FILE, "<", $file or die "Cannot open $file\n";
    my $artist = $file;
    $artist =~ s/^lyrics\///;
    $artist =~ s/.txt$//;
    $artist =~ tr/_/ /;
    
    while (my $line = <FILE>) {
        $line =~ tr/A-Z/a-z/;
        foreach my $word ($line =~ /[a-z]+/g) {
            $word_count{$word}++;
        }
    }

    my $total = 0;
    foreach my $word (keys %word_count) {
        $total += $word_count{$word};
    }
    
    my $decimal;
    my $matches;
    if (exists $word_count{$find}) {
        $decimal = sprintf("%.9f", $word_count{$find}/$total);
        $matches = $word_count{$find};
    } else {
        $decimal = "0.000000000";
        $matches = "0";
    }
    
    print "$matches/$total = $decimal $artist\n";
    
    close FILE;
}
