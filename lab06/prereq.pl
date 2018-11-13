#!/usr/bin/perl -w

use strict;

my $course_code = "$ARGV[0]";
my @course_level = ("undergraduate", "postgraduate");
my @prereqs;

foreach my $type (@course_level) {
    my $url = "http://www.handbook.unsw.edu.au/$type/courses/2018/$course_code.html";

    open FILE, "-|", "wget -q -O- $url" or die;
    
    while (my $line = <FILE>) {
        if ($line =~ /Prerequisite(s?): /) {
            my $delimiter = "</p>";
            @prereqs = split "$delimiter", "$line";
            $prereqs[0] =~ s/ *<p>Prerequisite(s?): [a-z 0-9]*//;
            
            my @matches;
            while ($prereqs[0] =~ m/([A-Z]{4}[0-9]{4})/g) {
                push @matches, $1;    
            }

            @prereqs = @matches;
            @prereqs = sort @prereqs;
            
            my $counter = 0;
            while ($counter < $#prereqs + 1) {
                $prereqs[$counter] =~ s/^\s+//;
                $prereqs[$counter] =~ s/\.$//;
                print "$prereqs[$counter]\n";
                $counter++;
            }       
        }
    }   
    close FILE; 
}

