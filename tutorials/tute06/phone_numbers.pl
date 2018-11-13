#!/usr/bin/perl -w

use strict;

# opening a webpage
foreach my $url (@ARGV) {
	open FILE, "-|", "wget -q -o- $url" or die;

	while (my $line = <FILE>) {
		# puts into @numbers -> everything that matches the regular expression (EVERY match)
		my @numbers = $line =~ /[\d\- ]+/g;
		foreach my $possible_numbers (@numbers) {
			# get rid of anyhting that isn't a number
			$possible_numbers =~ s/\D//g;
			print "$possible_numbers\n" if length $possible_numbers >= 8 && length $possible_numbers <= 15;
		}
	}

	close FILE;
}