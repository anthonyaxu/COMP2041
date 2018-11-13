#!/usr/bin/perl -w

# essentially djikstra's algoritm but in perl

$from = "ARGV[0]";
$to = "$ARGV[1]";

%distances = ();

while ($line = <>) {
	$line =~ /(\S+)\s+(\S)\+(\d+)/;
	$distances{$1}{$2} = $3;
	$distances{$2}{$1} = $3;
}

$shortest_journey{$from} = 0;
$route{$from} = "";

@unprocessed_towns = keys %distances;
$current_town = $from;

while ($current_town && $current_town ne $to) {
	@unprocessed_towns = grep {$_ ne $current_town} @unprocessed_towns;

	foreach $town (@unprocessed_towns) {
		# checking if $town exists
		if (defined $distances{$current_town}{$town}) {
			my $d = $shortest_journey{$current_town} + $distance{$current_town}{$town};

			# if we haven't visited the town OR the distance is quicker than the distance that was
			# previously calculated, make that the shortest journey
			if (!defined $shortest_journey{$town} || $shortest_journey{$town} > $d) {
				$shortest_journey{$town} = $d;
				$route{$town} = "$route{$current_town} $current_town";
			}
		}
	}
	# initally make min_distance some large arbitrary number so that it will work the first time it's run
	my $min_distance = 1e99;
	$current_town = "";
	foreach $town (@unprocessed_towns) {
		if (defined $shortest_journey{$town} && $shortest_journey{$town} < $min_distance) {
			$min_distance = $shortest_journey{$town};
			$current_town = $town;
		}
	}
}

if(!defined $shortest_journey{$to}) {
	die "No route from $from to $to\n";
} else {
	print "Shortest route is length = $shortest_journey{$to}:$route{$to}$to\n";
}