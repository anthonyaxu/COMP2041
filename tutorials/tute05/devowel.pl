#!/usr/bin/perl -w
# -w check for invalid variables

# <> can also be interpreted as <STDIN>
while ($line = <STDIN>) {
    # ~ expresses wanting to feed contents in $line into the editor ("s/[aeiou]//gi") and put it back into $line (testing a regular expression)
    # g stands for globally, remove every occurance that matches
    $line =~ s/[aeiou]//gi;
    print $line;
}

# the above code can also be written as below
# while (<>) {
#     # if not assigned to a variable, it will place it into a default variable  
#     s/[aeiou]gi//;
#     print;
# }