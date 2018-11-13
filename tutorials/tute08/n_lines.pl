#!/usr/bin/perl -w

# question 9

$n = shift @ARGV or die "$0: <number of lines>\n";

sub n_lines {
	# collecting arguments from when it is called [ print n_lines(...) ]
	my ($n) = @_;
	$counter = 0;
	$output = "";
	while ($counter < $n) {
		# ".=" appends string to $output, short version of saying $output = $output + <STDIN>
		$output .= <STDIN>;

		# chomp removes the last character in the string, it is the new line character in this case
		chomp $output;
		$counter++;
	}
	return $output."\n";
}

# can put as many arguments when calling subroutine
print n_lines($n);