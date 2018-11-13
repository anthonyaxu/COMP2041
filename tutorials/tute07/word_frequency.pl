#!/usr/bin/perl -w

use strict;

my %word_count = ();

while ($my line = <STDIN>) {
	# change line all into to lowercase characters
	$line =~ tr/A-Z/a-z/;

	# find each iteration of consecutive lowercase characters
	foreach my $word ($line =~ /[a-z]+/g) {
		$word_count{$word}++;
	}
}

my @word_keys = keys %word_count;
my @sorted_keys = sort { $word_count{$a} <=> $word_count{$b} } @word_keys;

foreach my $word (@sorted_keys) {
	print "$word_count{$word} $word\n"
}