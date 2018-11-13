#!/usr/bin/perl -w

use strict;

my $file = "$ARGV[0]";

open FILE, "<", $file or die "$0: can't open $file";
my @contents = <FILE>;
my $contents_size = $#contents + 1;

my $counter = 0;
my @contents_lower;
my @species_array;

while ($counter < $contents_size) {
    @contents_lower[$counter] = (lc $contents[$counter]);
    $contents_lower[$counter] =~ s/ ( *)/ /g;
    $contents_lower[$counter] =~ s/s? *$//;
    
    $species_array[$counter] = $contents_lower[$counter];
    $species_array[$counter] =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2} *[0-9]*//;
    $species_array[$counter] =~ s/^ *//;
    $species_array[$counter] =~ s/ *$//;
    $counter++;
}

@species_array = sort @species_array;
my @species_uniq;
my %seen;

foreach my $value (@species_array) {
    if (! $seen {$value}) {
        push @species_uniq, $value;
        $seen{$value} = 1;
    }
}

my $species_size = $#species_uniq + 1;

$counter = 0;
my $counter2 = 0;
my $counter3 = 0;
my $index = 0;
my $index2 = 0;

my @pods_total;
my @species_total;
my @matches;

my $species_type;
my @species_sum;

while ($counter < $species_size) {
    @matches = ();
    $counter2 = 0;
    $index = 0;
    while ($counter2 < $contents_size) {
        $species_type = $species_uniq[$counter];
        $species_type =~ s/\n$//;
        if ($contents_lower[$counter2] =~ /[0-9]+ $species_type$/) {
            $matches[$index] = $contents_lower[$counter2];
            $index++;
        }
        $counter2++;
    }
    $pods_total[$index2] = $#matches + 1;
    $counter3 = 0;
    while ($counter3 < $pods_total[$index2]) {
        $matches[$counter3] =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2} //;
        $matches[$counter3] =~ s/\D//g;
        $species_sum[$index2] += $matches[$counter3];
        $counter3++;
    }
    $index2++;
    $counter++;
}

$counter = 0;
while ($counter < $species_size) {
    $species_uniq[$counter] =~ s/\n$//;
    $species_uniq[$counter] = (lc $species_uniq[$counter]);
    print "$species_uniq[$counter] observations: $pods_total[$counter] pods, $species_sum[$counter] individuals\n";
    $counter++;
}

close FILE;
