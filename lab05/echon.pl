#!/usr/bin/perl -w

if (@ARGV == 2) {
    if ($ARGV[0] =~ /^\d+$/) {
        $n = $ARGV[0];
        $counter = 0;
        while ($counter < $n) {
            print "$ARGV[1]\n";
            $counter++;
        }     
    } else {
        print "./echon.pl: argument 1 must be a non-negative integer\n";
    }
} else {
    print "Usage: ./echon.pl <number of lines> <string>\n";
}
