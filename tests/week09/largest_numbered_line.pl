#!/usr/bin/perl -w

%hash = ();
$largest = 0;
$check = 0;
$counter = 0;
while ($line = <STDIN>) {
    @numbers = ();
    @numbers = $line =~ /(-?.?\d+\.?\d*)/g;
    
    foreach $digits (@numbers) {
        $digits =~ s/^[A-Za-z]+//;
        $digits =~ s/^\s*//;
        if ($digits !~ /^\d/) {
            if ($digits !~ /^\-?\.?\d+/) {
                @numbers = grep { $_ ne "$digits" } @numbers;
            }
        }
        if ($digits =~ /\.0*$/) {
            $digits =~ s/\.0*$//;
        }
    }
    
    if ($#numbers + 1 < 1) {
        next;
    }
    
    $line_largest = get_largest(\@numbers);
    $line_largest =~ s/^\s*//;
    
    if ($check == 0) {
        $largest = $line_largest;
        $check = 1;
    }
    
    if ($line_largest > $largest) {
        $largest = $line_largest;
    }
    
    if ($line_largest == $largest) {
        $hash{$line_largest}{$counter} = $line;
        $counter++;
    } else {
        $hash{$line_largest}{1} = $line;
    }
}

foreach $digit (sort keys % {$hash{$largest}}) {
    print "$hash{$largest}{$digit}";
}

sub get_largest {
    my ($numbers) = @_;
    
    $biggest = $numbers[0];
    
    foreach $digit (@numbers) {
        if ($digit > $biggest) {
            $biggest = $digit;
        }
    }
    return $biggest;
}
