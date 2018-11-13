#!/usr/bin/perl -w

$file = "$ARGV[0]";

open FILE, "<", "$file" or die;
@contents = <FILE>;
$counter = 0;
$total = 0;
while ($counter < $#contents + 1) {
    if ($contents[$counter] =~ /\"price\": /) {
        # print "$contents[$counter]\n";
        $contents[$counter] =~ s/\{\"name\": \"[A-Za-z ]+\", \"price\": \"\$//;
        $contents[$counter] =~ s/\"\},?$//;
        $contents[$counter] =~ s/^\s+//;
        #print "$contents[$counter]\n";
        $total += $contents[$counter];
    }
    $counter++;
}
$total = $total;
$number = sprintf("%.2f", "$total");
print "\$"."$number\n";

close FILE;
