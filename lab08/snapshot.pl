#!/usr/bin/perl -w

if ($#ARGV < 0) {
    die "Usage: $0 <save> or <load>\n";
}
$type = "$ARGV[0]";

if ("$type" eq "save") {
    save();
} elsif ("$type" eq "load") {
    if ($#ARGV < 1) {
        die "Usage: $0 load <number>\n";
    } else {
        $n = "$ARGV[1]";
        save();
        $direc = ".snapshot.$n";
        print "Restoring snapshot $n\n";
        if (-d "$direc") {
            foreach $file (glob "*") {
                if ("$file" eq "snapshot.pl") {
                    next;
                } else {
                    #print "$file\n";
                    unlink "$file";
                }
            }
            foreach $file (glob "$direc/*") {
                if ("$file" eq "snapshot.pl") {
                    next;
                } else {
                    $file_direc = $file;
                    #print "$file\n";
                    $file =~ s/^.snapshot.[\d+]\///;
                    #print "$file\n";
                    copy_file($file_direc, $file);
                }
            }
        } else {
            die "$direc does not exist\n";
        }
    }
} else {
    print "Usage: $0 <save> or <load>\n";
    exit 1;
}

sub save {
    $counter = 0;
    while (1) {
        if (-d ".snapshot.$counter") {
            $counter++;
        } else {
            $direc = ".snapshot.$counter";
            mkdir "$direc";
            print "Creating snapshot $counter\n";
            last;
        } 
    }
    foreach $file (glob "*") {
        if ("$file" eq "snapshot.pl") {
            next;
        } else {
            copy_file($file, "$direc/$file");
        }
    }
}

sub copy_file {
    my ($file, $dest) = @_;
    open SRC, "<", "$file" or die;
    open DEST, ">", "$dest" or die "Can't open $dest\n";
    while ($line = <SRC>) {
        print DEST "$line";
    }
    close SRC;
    close DEST;
}
