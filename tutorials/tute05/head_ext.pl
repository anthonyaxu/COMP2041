#!/usr/bin/perl -w

# question 4

use strict;

# default number of lines to display
my $nlines = 10;

my $temp_lines = $ARGV[0];

if (@ARGV && $temp_lines =~ /^-\d+$/) {
	$temp_lines =~ s/^-//;
	$nlines = $temp_lines;
	shift @ARGV;
}

if (@ARGV) {
	foreach my $file (@ARGV) {
		# read content on right into the left
		# can use "warn" instead of "die", will print error message but not exit the program
		open FILE, "<", $file or die "Cannot find $file\n";
		# put data from $file into an array @contents
		my @contents = <FILE>;
		print "==> $file <==\n";
		my $printed_lines = 0;
		while ($printed_lines < $nlines) {
			print $contents[$printed_lines];
			$printed_lines++
		}
		close FILE;
	}
} else {
	my $printed_lines = 0;
	while (my $line = <STDIN>) {
		if ($printed_lines >= $nlines) {
			last;
		}
		print $line;
		$printed_lines++;
	}
}
