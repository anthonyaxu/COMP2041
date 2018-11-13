#!/usr/bin/perl -w

$swapped = 1;
$counter = 0;
while ($swapped) {
    $swapped = 0;
    for ($counter = 0; $counter < $#ARGV; $counter++) {
        if ($ARGV[$counter] > $ARGV[$counter + 1]) {
            $temp = $ARGV[$counter];
            $ARGV[$counter] = $ARGV[$counter + 1];
            $ARGV[$counter + 1] = $temp;
            $swapped = 1;
        }
    }
}

$half = $#ARGV / 2;

print "$ARGV[$half]\n";
