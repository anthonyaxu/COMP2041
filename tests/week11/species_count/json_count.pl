#!/usr/bin/perl -w

$target = "$ARGV[0]";
$file = "$ARGV[1]";

open FILE, "<", $file or die;
@contents = <FILE>;
close FILE;

$counter = 0;
$sum = 0;
while ($counter < $#contents + 1) {
    if ($contents[$counter] =~ /\"species\": \"$target\"/) {
        $how_many = $contents[$counter-1];
        $how_many =~ s/^\s+\"how_many\": //;
        $how_many =~ s/,$//;
        chomp $how_many;
        $sum += $how_many;
    }
    $counter++;
}
print "$sum\n";
