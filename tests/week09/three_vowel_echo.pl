#!/usr/bin/perl -w

foreach $word (@ARGV) {
    if ($word =~ /[AEIOUaeiou]{3}/) {
        print "$word ";
    }
}

print "\n";
