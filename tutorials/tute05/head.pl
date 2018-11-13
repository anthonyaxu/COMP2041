#!/usr/bin/perl -w

# question 3

use strict;

# variable is global
# our $var = 3;

# only exists in scope of proogram
# my $variable = 4;

# default number of lines to display
my $nlines = 10;

my $temp_lines = $ARGV[0];

# /^-\d+$/ = match entire string, be only be composed of digits 
if (@ARGV && $temp_lines =~ /^-\d+$/) {
	$temp_lines =~ s/^-//;
	$nlines = $temp_lines;
}

my $printed_lines = 0;
while (my $line = <STDIN>) {
	if ($printed_lines >= $nlines) {
		last;
	}
	print $line;
	$printed_lines++;
}

# next (in perl) == continue (in C)
# last (in perl) == break (in C)