#!/usr/bin/perl -w

## test code to check if you can match strings this way
# $re = $ARGV[0];
# $test = $ARGV[1];

# if ($test =~ /$re/) {
# 	print "true\n";
# } else {
# 	print "false\n";
# }

use strict;

my $re = $ARGV[0];
shift @ARGV;

foreach my $file (@ARGV) {
	open FILE, "<", $file or die "Cannot open $file\n";
	my @contents = <FILE>;
	my $line_num = 0;
	foreach my $line (@contents) {
		if ($line =~ /$re/) {
			print "$file:$line_num $line";
		}
		$line_num++;
	}
}