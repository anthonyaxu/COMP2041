#!/usr/bin/perl -w

$file = "$ARGV[0]";

open FILE, "<", $file or die "$0: cannot open $file";

@contents = <FILE>;
$size = $#contents + 1;
$half = $size / 2;
if ($size < 1) {

} elsif ($size % 2 == 0) {
    print "$contents[$half - 1]";
    print "$contents[$half]";
} else {
    print "$contents[$half]";
}

close FILE;
