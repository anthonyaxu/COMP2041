#!/usr/bin/perl -w

$file = "$ARGV[0]";

open FILE, "<", $file or die;
@contents = <FILE>;
close FILE;

$counter = 0;
while ($counter < $#contents + 1) {
    $contents[$counter] =~ tr/[0-9]/#/;
    $contents[$counter] =~ s/^\s+//;
    $counter++;
}

open FILE, ">", $file or die;
truncate FILE, 0;
$counter = 0;
while ($counter < $#contents + 1) {
    print FILE "$contents[$counter]";
    $counter++;
}
close FILE;
