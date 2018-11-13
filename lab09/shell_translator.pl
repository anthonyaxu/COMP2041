#!/usr/bin/perl -w

## echo "something" ---> print "something" . "\n"; only add  . "\n"; at the end and replace echo
## chomp when reading in perl because shell doesn't read the new line

$file = "$ARGV[0]";

open FILE, "<", $file or die "Can't open $file\n";

while ($line = <FILE>) {
    $line =~ /^( *)/;
    $count = length($1);
    $string = add_spaces($count);
    
    if ($line =~ "#!/bin/bash") {
        print "#!/usr/bin/perl -w\n";
    } elsif ($line =~ "^# ") {
        print "$line";
    } elsif ($line =~ /^\n/ || $line =~ " *do\n" || $line =~ " *then\n") {
        next;
    } elsif ($line =~ "^ *done\n" || $line =~ "^ *fi\n") {
        print $string . "}\n";
    } elsif ($line =~ /[A-Za-z]+=[0-9]+/) {
        $line =~ s/=/ = /g;
        $line =~ s/ *//;
        $line = "\$$line";
        chomp $line;
        print "$string" . "$line" . ";\n";
    } elsif ($line =~ "while (.*)") {
        $line =~ /\(\((.*)\)\)/;
        @statement = split / /,$1;
        @array = add_dollars(@statement);
        print $string . "while (" . "@array" . ") {\n";
    } elsif ($line =~ /[a-z]*=\$/) {
        $line =~ s/=/ = /;
        $line =~ s/ *//;
        $line = "\$$line";  
        $line =~ s/[\$\(\)]//g;
        chomp $line;
        @statement = split / /,$line;
        @array = add_dollars(@statement);
        print "$string" . "@array" .";\n";
    } elsif ($line =~ "echo ") {
        $line =~ s/echo /print "/;
        chomp $line;
        print "$line" . '\n";' . "\n";
    } elsif ($line =~ /if \(/) {
        $line =~ /\(\((.*)\)\)/;
        @statement = split / /,$1;
        @array = add_dollars(@statement);
        print $string . "if (" . "@array" . ") {\n";
    } elsif ($line =~ " *else\n") {
        print $string . "} else {\n";
    }
}

close FILE;

sub add_dollars {
    my (@array) = @_;
    $counter = 0;
    while ($counter < $#array + 1) {
        if ($array[$counter] =~ /[a-z]+/) {
            $array[$counter] = "\$$array[$counter]";
        }
        $counter++;
    }

    return @array;
}

sub add_spaces {
    my ($count) = @_;
    $counter = 0;
    $string = "";
    while ($counter < $count) {
        $string .= " ";
        $counter++;
    }
    return $string;
}
