#!/usr/bin/perl -w

use strict;

my $direc_one = "$ARGV[0]";
$direc_one =~ s/\/$//;
my $direc_two = "$ARGV[1]";
$direc_two =~ s/\/$//;

my %hash = ();

foreach my $fone (glob "$direc_one/*") {
    foreach my $ftwo (glob "$direc_two/*") {
        my $one_name = $fone;
        my $two_name = $ftwo;
        $one_name =~ s/^$direc_one\///g;
        $two_name =~ s/^$direc_two\///g;
        
        if ("$one_name" eq "$two_name") {
            if (files_same($fone, $ftwo)) {
                $hash{$one_name} = $fone; 
            }
        }
    }
}

foreach my $file (sort keys %hash) {
    print "$file\n";
}

sub files_same {
    my ($src, $dest) = @_;
    my $check = 0;
    open SRC, "<", $src or die;
    open DEST, "<", $dest or die;

    my @scontents = <SRC>;
    my @dcontents = <DEST>;

    # If the number of lines are different, files are different
    if ($#scontents != $#dcontents) {
        return 0;
    }

    # Checks every line to see if they match or not
    my $counter = 0;
    while ($counter < $#scontents + 1) {
        if ("$scontents[$counter]" ne "$dcontents[$counter]") {
            $check = 1;
            # Could return here but have to also close files, easier on me to keep it all at the bottom
        }
        $counter++;
    }
    
    close SRC;
    close DEST;
    if ($check == 0) {
        return 1;
    } else {
        return 0;
    }
}
