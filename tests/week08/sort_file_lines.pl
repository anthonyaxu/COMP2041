#!/usr/bin/perl -w

$file = "$ARGV[0]";

open FILE, "<", $file or die "$0 cannot open $file\n";

%line_length = ();
while ($line = <FILE>) {
    $line_length{$line} = length($line);
}

close FILE;

foreach $line (sort {$line_length{$a} <=> $line_length{$b} || ($a cmp $b) } keys %line_length) {
    print "$line";
}
