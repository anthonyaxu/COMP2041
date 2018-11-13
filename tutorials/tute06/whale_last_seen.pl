#!/usr/bin/perl -w

use strict;

our %last_seen = ();

foreach my $filename (@ARGV) {
	open FILE, "<", $filename or die "$0: cannot open $filename\n";
	my $current_date = "";
	my $current_count = 0;
	my $current_species = "";
	while (my $line = <FILE>) {
		if ($line =~ /^(\S+)\s+(\d+)\s+(.+)\s*$/) {
			my $species = $3;
			my $date = $1;
			$last_seen{$species} = $date;
		} else {
			die "Cannot parse: $line\n";
		}
	}

	# order of plaing reverse/sort is from right to left
	foreach my $species (sort keys %last_seen) {
		print "$species $last_seen{$species}\n";
	}
	close FILE;
}