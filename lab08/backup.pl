#!/usr/bin/perl -w

$file = "$ARGV[0]";

$number = 0;

while (1) {
    if (-f ".$file.$number") {
        $number++;
    } else {
        $backup = ".$file.$number";
        copy_file($file, $number);
        print "Backup of '$file' saved as '$backup'\n";
        last;
    }
}

sub copy_file {
    my ($file, $number) = @_;
    open SRC, "<", $file or die;
    open DEST, ">", ".$file.$number" or die;
    while ($line = <SRC>) {
        print DEST "$line";
    }
    close SRC;
    close DEST;
}
