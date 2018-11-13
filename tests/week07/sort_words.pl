#!/usr/bin/perl -w

while ($line = <STDIN>) {
    @array = split ' ', "$line";
    @array = sort { $a cmp $b } @array;
    print "@array\n";
}
