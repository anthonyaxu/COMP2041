#!/usr/bin/perl -w

if (($#ARGV + 1) < 2) {
    print "Usage: $0 <files>\n";
} else {
    $first_file = "$ARGV[0]";
    open FILE, "<", $first_file or die;
    @original = <FILE>;
    close FILE;
    
    @argv = @ARGV;
    splice @argv, 0, 1;
    
    foreach $file (@argv) {
        open FILE, "<", $file or die;
        
        @compare = <FILE>;
        if ($#original != $#compare) {
            print "$file is not identical\n";
            exit 1;
        } else {
            $counter = 0;
            while ($counter < $#original + 1) {
                $original_line = $original[$counter];
                $compare_line = $compare[$counter];
                
                if ($original_line ne $compare_line) {
                    print "$file is not identical\n";
                    exit 1;
                }
                
                $counter++;
            }
        }
        close FILE;
    }
}

print "All files are identical\n";
