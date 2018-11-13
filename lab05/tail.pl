#!/usr/bin/perl -w

use strict;

my $nlines = 10;

my $temp_lines = $ARGV[0];

if (@ARGV && $temp_lines =~ /^-\d+$/) {
    $temp_lines =~ s/^-//;
    $nlines = $temp_lines;
    shift @ARGV;
}

if (@ARGV) {
	foreach my $file (@ARGV) {
		open FILE, "<", $file or die "$0: can't open $file";
		my @contents = <FILE>;
		my $total_lines = $#contents + 1;

		if ($#ARGV + 1 > 1) {
		    print "==> $file <==\n";
		}
		my $counter = 0;
		if ($total_lines < $nlines) {
		    print $contents[$counter];
		    $counter++;
		} else {
		    my $printed_lines = 0;
            my $start_index = $total_lines - $nlines;
            while ($printed_lines < $nlines) {
                if ($start_index > $total_lines) {
                    last;
                }
                print $contents[$start_index];
                $start_index++;
                $printed_lines++;
            }
        }
		close FILE;
	}
} else {
    my @contents;
    while (my $line = <STDIN>) {
        push @contents, $line;
    }
    my $printed_lines = 0;
    my $total_lines = $#contents + 1;
    my $start_index = $total_lines - $nlines;
    while ($printed_lines < $nlines) {
        if ($start_index > $total_lines) {
            last;
        }
        print $contents[$start_index];
        $start_index++;
        $printed_lines++;
    }
}

