#!/usr/bin/perl -w

# question 11

$file = shift @ARGV or die "$0: <filename>\n";

open FILE, "<", "$file" or die "$0: Cannot open $file\n";

while ($line = <FILE>) {
	# !~  true if the regex doesn't match
	# checks if start of a line is an alphanumeric character, no space or !, ?, @, etc
	if ($line =~ /^[A-Za-z]/) {
		$line =~ /^([A-Za-z][A-Za-z0-9]*) +([A-Za-z_][A-Za-z0-9_]*)\(([A-Za-z][A-Za-z0-9]* *\**) \)/;  # fix problem
		print "$1, $2, $3\n";
	}

	# print "function type='$function_type'\n";
	# print "function_name='$function_name'\n";
	# print "parameter tyoe-;$parameter_type'\n";
	# print "parameter name='$parameter_name'\n";
}