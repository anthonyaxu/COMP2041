#!/usr/bin/perl -w

use strict;

foreach my $filename (@ARGV) {
	open FILE, "<", $filename or die "$0: cannot open $filename\n";
	my $current_date = "";
	my $current_count = 0;
	my $current_species = "";
	while (my $line = <FILE>) {
		if ($line =~ /^(\S+)\s+(\d+)\s+(.+)\s*$/) {
			my$species = $3;
			my $date = $1;
			my $count = $2;

			if ($current_species eq $species && $current_date eq $date) {
				$current_count += $count;
			} else {
				if ($counter > 0) {
					print "$current_date $current_count $current_species\n";
				}
				$current_species = $species;
				$current_date = $date;
				$current_count = $count;
			}
		} else {
			# yeah look incomplete
			# don't know the whole code whoops
		}
	}
	close FILE;
}