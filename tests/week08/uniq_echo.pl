#!/usr/bin/perl -w

$input = "@ARGV";
@words = split / /,$input;

%frequency = ();
$counter = 0;
$index = 0;
while ($counter < $#words + 1) {
    if (exists $frequency{$words[$counter]}) {
        $counter++;
        next;
    } else {
        $frequency{$words[$counter]} = $index;
        $counter++;
        $index++;
    }
}

foreach $word ( sort { $frequency{$a} <=> $frequency{$b} } keys %frequency ) {
    print "$word ";
}

print "\n";
