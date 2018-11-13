#!/usr/bin/perl -w

$n = "$ARGV[0]";

$check = 1;
$frequency = ();
while ($line = <STDIN>) {
    $frequency{$line}++;
    if ($check == 0) {
        if ($frequency{$line} == $n) {
            $word = $line;
            last;
        }
    }
    $check = 0;
}

if (defined($word)) {
    print "Snap: $word";
}
