#!/usr/bin/perl -w

# artist name --> word ---> individual word frequency

%artist_wc = ();
foreach $file (glob "lyrics/*.txt") {
    open FILE, "<", $file or die "Cannot open $file\n";
    $artist = $file;
    $artist =~ s/^lyrics\///;
    $artist =~ s/.txt$//;
    $artist =~ tr/_/ /;
    
    while ($line = <FILE>) {
        $line =~ tr/A-Z/a-z/;
        foreach $word ($line =~ /[a-z]+/g) {
            $word_count{$artist}{$word}++;
        }
    }
    
    $total_words = 0;
    foreach $word (keys % {$word_count{$artist}}) {
        $total_words += $word_count{$artist}{$word};
    }
    $artist_wc{$artist} = $total_words;
    
    close FILE;
}

if ("$ARGV[0]" eq "-d") {
    $song = "$ARGV[1]";
    
    open FILE, "<", $song or die;
    
    while ($line = <FILE>) {
        $line =~ tr/A-Z/a-z/;
        foreach $word ($line =~ /[a-z]+/g) {
            $song_words{$word}++;
        }
    }
    
    foreach $word (keys %song_words) {
        $frequency = $song_words{$word};
        foreach $artist (keys %artist_wc) {
        
            if (exists $word_count{$artist}{$word}) {
                $appearances = $word_count{$artist}{$word};
            } else {
                $appearances = 0;
            }
        
            $decimal = sprintf("%8.4f", (log(($appearances + 1)/($artist_wc{$artist})))*$frequency);
            $log_hash{$artist} += $decimal;
        }
    }
    
    @sorted_logs = reverse sort {$log_hash{$a} <=> $log_hash{$b}} keys %log_hash;
    
    foreach $artist (reverse sort {$log_hash{$a} <=> $log_hash{$b}} keys %log_hash) {
        $number = sprintf("%.1f", $log_hash{$artist});
        print "$song: log probability of $number for $artist\n";
    }
    $most_like_artist = $sorted_logs[0];
    $number = sprintf("%.1f", $log_hash{$most_like_artist});
    print "$song most resembles the work of $most_like_artist (log probability=$number)\n";
    
    close FILE;
} else {
    foreach $song (@ARGV) {
        open FILE, "<", $song or die;
        
        %song_words = ();
        
        while ($line = <FILE>) {
            $line =~ tr/A-Z/a-z/;
            foreach $word ($line =~ /[a-z]+/g) {
                $song_words{$word}++;
            }
        }
        
        %log_hash = ();
        
        foreach $word (keys %song_words) {
            $frequency = $song_words{$word};
            foreach $artist (keys %artist_wc) {
            
                if (exists $word_count{$artist}{$word}) {
                    $appearances = $word_count{$artist}{$word};
                } else {
                    $appearances = 0;
                }
            
                $decimal = sprintf("%8.4f", (log(($appearances + 1)/($artist_wc{$artist})))*$frequency);
                $log_hash{$artist} += $decimal;
            }
        }
        
        @sorted_logs = reverse sort {$log_hash{$a} <=> $log_hash{$b}} keys %log_hash;
        $most_like_artist = $sorted_logs[0];
        $number = sprintf("%.1f", $log_hash{$most_like_artist});
        print "$song most resembles the work of $most_like_artist (log-probability=$number)\n";
        
        close FILE;
    }
}
