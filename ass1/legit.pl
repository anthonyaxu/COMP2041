#!/usr/bin/perl -w

# legit.pl, implementing a subset of the version control system Git
# Assignment 1 for COMP2041, UNSW Semester 2, 2018
# by Anthony Xu - z5165674@cse.unsw.edu.au

use strict;

sub main {
    if ($#ARGV < 0) {
        print_usage();
        exit 1;
    }

    my $command = "$ARGV[0]";
    splice @ARGV, 0, 1;

    # Path to index sub-directory
    my $index_dir = ".legit/.git/index";

    my $argc = $#ARGV + 1;

    if ($command eq "init") {
        my $repo = ".legit";
        if (dir_exists($repo)) {             # Checks if the repo has already been created
            print STDERR "legit.pl: error: $repo already exists\n";
            exit 1;
        } else {
            initialise_repo();
        }
    } elsif ($command eq "add") {
        # Checks to make sure there is a .legit repo initialised
        check_init();

        # Hash to store all the files that can be added to the index
        my %files_to_add = ();
        # Hash to store all the files that will be removed from the index
        my %files_to_remove = ();

        foreach my $file (@ARGV) {
            if (file_name_check($file)) {       # Checking if file name is valid
                if (file_exists($file)) {
                    my $dest = "$index_dir/$file";
                    # If the file can be added to the index, save it in a hash to make sure that all files can be added
                    # i.e will only add files if and only if all the files can be added to index
                    $files_to_add{$file} = $dest;
                } else {
                    # Check if file is still in the index --> adding and committing it will remove it from the index
                    my $findex = "$index_dir/$file";
                    if (file_exists($findex)) {
                        # Store the path of the file to be removed
                        $files_to_remove{$file} = $findex;
                    } else {
                        print STDERR "legit.pl: error: can not open '$file'\n";
                        exit 1;
                    }
                }
            } else {
                if ($file =~ /^\-/) {
                    print_add_usage();
                }
                print STDERR "legit.pl: error: invalid filename '$file'\n";
                exit 1;
            }
        }

        # Add all files to the index
        foreach my $add (keys %files_to_add) {
            copy_file($add, $files_to_add{$add});
        }

        my $removing = 0;
        # Remove selected files from the index
        foreach my $remove (keys %files_to_remove) {
            remove_file($files_to_remove{$remove});
            $removing++;
        }

        if ($removing > 0) {
            create_index_delete($removing);
        }

    } elsif ($command eq "commit") {
        check_init();
        
        if ($argc < 1) {
            print_commit_usage();
        }

        # If last argument of line is '-m' exit and print error
        if ("$ARGV[$argc - 1]" eq "-m") {
            print_commit_usage();
        }
        my $counter = 0;
        while ($counter < $#ARGV) {
            if (($counter + 2) > $#ARGV) {
                last;
            }
            if ("$ARGV[$counter]" eq "-m") {
                my $two_ahead = $counter + 2;
                if ("$ARGV[$two_ahead]" ne "-m") {
                    if ("$ARGV[$two_ahead]" ne "-a") {
                        print_commit_usage();
                    }
                }
            }
            $counter++;
        }

        my $argument = "@ARGV";
        # Capture all the words that start with '-'
        my @matches = $argument =~ /(-\S+)/g;
        # Probably don't need this because it's assumed we won't be given any command that isn't -m or -a
        foreach my $word (@matches) {
            if ("$word" ne "-m") {
                if ("$word" ne "-a") {
                    print_commit_usage();
                }
            }
        }

        # Get all strings after -m
        my @input_message = $argument =~ /-m ([\w ]+)/g;
        if (($#input_message + 1) < 1) {
            print_commit_usage();
        }

        # Check if messages are '-a'
        foreach my $word (@input_message) {
            if ($word =~ /-a/) {
                print_commit_usage();
            }
        }

        # The message after the last '-m' will be the message will be input when it is committed
        my $last_message = $#input_message;
        my $message = $input_message[$last_message];

        if ($argument =~ /-m/ and $argument =~ /-a/) {
            # Remove '-a' and '-m' from @ARGV
            @ARGV = grep {$_ ne "-a"} @ARGV;
            @ARGV = grep {$_ ne "-m"} @ARGV;
            
            # Check to see if the commit message is valid or not
            check_commit_message($message);
            # Updates all the files in the index with files from the current directory
            update_index();
            # Commits all the files in the index
            commit_files($message);
        } elsif ($argument =~ /-m/) {
            @ARGV = grep {$_ ne "-m"} @ARGV;
            check_commit_message($message);
            commit_files($message);
        } else {
            print_commit_usage();
        }
    } elsif ($command eq "log") {
        check_init();

        if ($argc != 0) {
            print_log_usage();
        }

        my $commit_size = check_commits();
        if ($commit_size < 1) {
            print STDERR "legit.pl: error: your repository does not have any commits yet\n";
            exit 1;
        }

        # Prints out all contents in log
        my $log = ".legit/.git/log";
        print_file($log);
    } elsif ($command eq "show") {
        check_init();

        my $commit_size = check_commits();
        if ($commit_size < 1) {
            print STDERR "legit.pl: error: your repository does not have any commits yet\n";
            exit 1;
        }

        if ($argc != 1) {
            print_show_usage();        
        } else {
            # Split the argument into the commit number and file name
            my @show = split /:/, $ARGV[0];
            my $commit_id = $show[0];
            my $file_name = $show[1];

            # Look for the file in the index if the first argument is empty
            if ($commit_id eq "") {
                my $findex = "$index_dir/$file_name";

                if (file_name_check($file_name)) {
                    if (file_exists($findex)) {
                        print_file($findex);
                    } else {
                        print STDERR "legit.pl: error: '$file_name' not found in index\n";
                        exit 1;                       
                    }
                } else {
                    print STDERR "legit.pl: error: invalid filename '$file_name'\n";
                    exit 1;
                }
            } else {
                if ($commit_id =~ /^[-#].*/) {
                    print_show_usage();
                } else {
                    my $commit_dir = ".legit/.git/commits/$commit_id";

                    # Check to see if the commit file exists
                    if (dir_exists($commit_dir)) {
                        my $commit_file = "$commit_dir/$file_name";
                        if (file_name_check($file_name)) {
                            if (file_exists($commit_file)) {
                                print_file($commit_file);
                            } else {
                                print STDERR "legit.pl: error: '$file_name' not found in commit $commit_id\n";
                                exit 1;                       
                            }
                        } else {
                            print STDERR "legit.pl: error: invalid filename '$file_name'\n";
                            exit 1;
                        }
                    } else {
                        print STDERR "legit.pl: error: unknown commit '$commit_id'\n";
                        exit 1;
                    }
                }
            }
        }
    } elsif ($command eq "rm") {
        check_init();

        # if ($argc < 1) {
        #     # Apparently not required to detect this error?
        #     exit 1;
        # }

        my $commit_size = check_commits();
        if ($commit_size < 1) {
            print STDERR "legit.pl: error: your repository does not have any commits yet\n";
            exit 1;
        }

        # Hashes to store the files which will be removed from their respective sub-directory
        my %remove_from_index = ();
        my %remove_from_dir = ();

        my $argument = "@ARGV";
        # Matches all instances of -.* or --.* and puts it into an array
        my @matches = $argument =~ /(-{1,2}\S+)/g;

        foreach my $word (@matches) {
            # Doesn't count if it is all numbers (eg. -234234123)
            if ("$word" =~ /^-{1,2}\d+$/) {
                next;
            }
            if ("$word" ne "--force") {
                if ("$word" ne "--cached") {
                    print_rm_usage();
                }
            }
        }
        my $counter = 0;
        my $counter2 = 0;
        my $flags = 0;
        while ($counter < $#ARGV) {
            if ("$ARGV[$counter]" !~ /^--/) {
                $counter2 = $counter;
                $flags = 0;
                while ($counter2 < $#ARGV) {
                    if ("$ARGV[$counter2]" =~ /^--/) {
                        $flags++;
                    } else {
                        if ($flags > 0) {
                            if ("$ARGV[$counter2]" !~ /^--/) {
                                print_rm_usage();
                            }
                        }
                    }
                    $counter2++;
                }
            }
            $counter++;
        }

        my $prev_commit_id = $commit_size - 1;
        my $prev_dir = ".legit/.git/commits/$prev_commit_id";

        if ($argument =~ /--force/ and $argument =~ /--cached/) {
            # Removes --force and --cached from ARGV
            @ARGV = grep {$_ ne "--force"} @ARGV;
            @ARGV = grep {$_ ne "--cached"} @ARGV;
            
            foreach my $file (@ARGV) {
                if (file_name_check($file)) {
                    my $findex = "$index_dir/$file";
                    if (file_exists($findex)) {
                        $remove_from_index{$file} = $findex;
                    } else {
                        print STDERR "legit.pl: error: '$file' is not in the legit repository\n";
                        exit 1;
                    }
                } else {
                    print STDERR "legit.pl: error: invalid filename '$file'\n";
                    exit 1;
                }
            }
        } elsif ($argument =~ /--force/) {
            @ARGV = grep {$_ ne "--force"} @ARGV;

            foreach my $file (@ARGV) {
                if (file_name_check($file)) {
                    my $findex = "$index_dir/$file";
                    if (file_exists($findex)) {
                        $remove_from_index{$file} = $findex;
                        if (file_exists($file)) {
                            $remove_from_dir{$file} = $file;
                        }
                    } else {
                        print STDERR "legit.pl: error: '$file' is not in the legit repository\n";
                        exit 1;
                    }
                } else {
                    print STDERR "legit.pl: error: invalid filename '$file'\n";
                    exit 1;
                }
            }
        } elsif ($argument =~ /--cached/) {
            @ARGV = grep {$_ ne "--cached"} @ARGV;

            foreach my $file (@ARGV) {
                if (file_name_check($file)) {
                    my $findex = "$index_dir/$file";
                    my $dir = "*";
                    if (file_exists($findex)) {
                        my $index_changed = check_unchanged($file, $index_dir, $prev_dir);
                        if ($index_changed) {
                            # Removes if index file is same as prev commit file
                            $remove_from_index{$file} = $findex;
                            next;
                        }
                        if (file_exists($file)) {
                            my $index_cur = check_unchanged($file, $dir, $index_dir);
                            # If index file is same as prev commit file
                            if ($index_changed) {
                                if (!$index_cur) {
                                    print STDERR "legit.pl: error: '$file' in repository is different to working file\n";
                                    exit 1;
                                }
                            } else {
                                if (!$index_cur) {
                                    # If index file DOESN'T match prev commit file AND index file DOESN'T match current directory file
                                    print STDERR "legit.pl: error: '$file' in index is different to both working file and repository\n";
                                    exit 1;
                                } else {
                                    $remove_from_index{$file} = $findex;
                                    next;
                                }
                            }
                        } else {
                            # TODO if file doesn't exist
                            # print some error
                        }
                    } else {
                        print STDERR "legit.pl: error: '$file' is not in the legit repository\n";
                        exit 1;
                    }
                } else {
                    print STDERR "legit.pl: error: invalid filename '$file'\n";
                    exit 1;
                }
            }
        } else {
            # All files already in @ARGV
            
            foreach my $file (@ARGV) {
                if (file_name_check($file)) {
                    my $findex = "$index_dir/$file";
                    my $dir = "*";
                    if (file_exists($findex)) {
                        if (file_exists("$prev_dir/$file")) {
                            my $index_changed = check_unchanged($file, $index_dir, $prev_dir);
                            if ($index_changed) {
                                # Removes if index file is same as prev commit file
                                $remove_from_index{$file} = $findex;
                            }
                            if (file_exists($file)) {
                                # Check if the file is the same as the file located in the previous commit
                                my $file_changed = check_unchanged($file, $dir, $prev_dir);
                                if ($file_changed) {
                                    $remove_from_dir{$file} = $file;
                                } else {
                                    my $index_cur = check_unchanged($file, $dir, $index_dir);
                                    # If index file is same as prev commit file
                                    if ($index_changed) {
                                        if (!$index_cur) {
                                            print STDERR "legit.pl: error: '$file' in repository is different to working file\n";
                                            exit 1;
                                        }
                                    } else {
                                        # If index file DOESN'T matches prev commit file AND index file matches current directory file
                                        if ($index_cur) {
                                            print STDERR "legit.pl: error: '$file' has changes staged in the index\n";
                                            exit 1;
                                        } else {
                                            # If index file DOESN'T match prev commit file AND index file DOESN'T match current directory file
                                            print STDERR "legit.pl: error: '$file' in index is different to both working file and repository\n";
                                            exit 1;
                                        }
                                    }
                                }
                            }
                            # TODO if file doesn't exist
                            # print some error
                                                  
                        } else {
                            print STDERR "legit.pl: error: '$file' has changes staged in the index\n";
                            exit 1;
                        }
                    } else {
                        print STDERR "legit.pl: error: '$file' is not in the legit repository\n";
                        exit 1;
                    }
                } else {
                    print STDERR "legit.pl: error: invalid filename '$file'\n";
                    exit 1;
                }
            }
        }

        my $removing = 0;
        # Removing from index
        foreach my $findex (keys %remove_from_index) {
            remove_file($remove_from_index{$findex});
            $removing++;
        }

        if ($removing > 0) {
            create_index_delete($removing);
        }

        # Removing from current directory
        foreach my $fdir (keys %remove_from_dir) {
            remove_file($remove_from_dir{$fdir});
        }
    } else {
        print_usage();
        exit 1;
    }
}

# Checks if a .legit repository has been initialised
# or not. Returns 1 if it does, 0 if it doesn't
sub check_init {
    my () = @_;
    if (-d ".legit") {
        return 1;
    } else {
        print STDERR "legit.pl: error: no .legit directory containing legit repository exists\n";
        exit 1;
    }
}

# Checks if any commits have been made
# Returns number of commits in sub-directory
sub check_commits {
    my () = @_;
    my @commits_made = <".legit/.git/commits/*">;     # get all the files in the .legit/.git/commits directory
    my $commit_size = @commits_made;                  # gets size of /commits/ directory
    return $commit_size;
}

# Creates a .file inside index to tell the future commit to 
# create an empty commit file (stop tracking a file)
sub create_index_delete {
    my ($removing) = @_;
    my $index_dir = ".legit/.git/index";
    my $delete_file = ".deleting";

    open DELETING, ">", "$index_dir/$delete_file" or die;
    print DELETING "$removing";
    close DELETING;
}

# Checks if the name of the file is valid
# Starts with alphanumeric (no '-') and can contain ['.', '-', '_']
# Returns 1 if valid, 0 if not
sub file_name_check {
    my ($file_name) = @_;
    if ($file_name =~ /^[A-Za-z0-9][A-Za-z0-9\_\.\-]*$/) {
        return 1;
    } else {
        return 0;
    }
}

# Return how many files have been untracked by the index
sub get_files_deleted {
    my () = @_;
    my $index_dir = ".legit/.git/index";
    my $delete_file = ".deleting";

    open DELETING, "<", "$index_dir/$delete_file" or die;
    my $number = <DELETING>;
    close DELETING;
    return $number;
}

# Checks if a file exists
# returns 1 if it does, returns 0 if it doesn't exist
sub file_exists {
    my ($file) = @_;
    if (-f $file) {
        return 1;
    } else {
        return 0;
    }
}

# Checks if a directory exists
# returns 1 if it does, returns 0 if it doesn't exist
sub dir_exists {
    my ($dir) = @_;
    if (-d $dir) {
        return 1;
    } else {
        return 0;
    }
}

# Makes a new copy of a file
# Copies every line from the source file and writes it
# to the destination file
sub copy_file {
    my ($src, $dest) = @_;
    open SRC, "<", $src or die "legit.pl: error: can not open '$src'\n";
    open DEST, ">", $dest or die;
    while (my $line = <SRC>) {
        print DEST "$line";
    }
    close SRC;
    close DEST;
}

# Subroutine that removes a file
sub remove_file {
    my ($file) = @_;
    unlink $file;
}

# Checks two files to see if they are the same or not
# Returns 1 if they are the same, 0 if not
sub is_file_same {
    my ($src, $dest) = @_;
    my $check = 0;
    open SRC, "<", $src or die;
    open DEST, "<", $dest or die;

    my @scontents = <SRC>;
    my @dcontents = <DEST>;

    # If the number of lines are different, files are different
    if ($#scontents != $#dcontents) {
        return 0;
    }

    my $counter = 0;
    while ($counter < $#scontents + 1) {
        if ("$scontents[$counter]" ne "$dcontents[$counter]") {
            $check = 1;
        }
        $counter++;
    }
    
    close SRC;
    close DEST;
    if ($check == 0) {
        return 1;
    } else {
        return 0;
    }
}

# Commits all files in .legit/.index and moves them
# into a new directory inside .legit/.commits, giving 
# each new commit a number
sub commit_files {
    my ($message) = @_;

    my $index_dir = ".legit/.git/index";
    my $deleted_files = 0;

    # 1 if file has not changed else 0
    my $changed = 0;

    if (file_exists("$index_dir/.deleting")) {
        # Get files untracked by index
        $deleted_files = get_files_deleted();
    }

    if (is_folder_empty($index_dir) == 0) {
        if (!file_exists("$index_dir/.deleting")) {
            print "nothing to commit\n";
            exit 0;
        }
        remove_file("$index_dir/.deleting");
    }

    # Checks how many commits have been made, assigns the value to the new id
    my $commit_id = check_commits();
    
    # Check previous commit (if it exists) and see if the files in index are same as previous commit's files
    if ($commit_id > 0) {
        my $prev_id = $commit_id - 1;
        my $prev_dir = ".legit/.git/commits/$prev_id";

        my @index_files = <"$index_dir/*">;
        # The number of files in the ../index sub-directory
        my $index_size = @index_files;
        
        # Add on the deleted files from index
        $index_size += $deleted_files;

        # Counter to keep track of the number of files that haven't been changed
        my $same_files = 0;
        
        # Gets the number of files that are the same in index and previous commit
        foreach my $file (@index_files) {
            # Removing the path to just get the file name by itself
            $file =~ s/$index_dir\///;
            $changed = check_unchanged($file, $index_dir, $prev_dir);
            $same_files += $changed;
        }

        # If all files in index haven't changed since the previous commit, exit
        if ($same_files == $index_size) {
            print "nothing to commit\n";
            exit 0;
        }
    }

    # Once we know we can commit, create a new commit folder in .legit/.git/commits
    initialise_commit($commit_id);
    my $commit_dir = ".legit/.git/commits/$commit_id";
    # Writes the user inputted message to the message file in the commit folder
    write_commit_message($commit_dir, $message);
    # Moves all the files from index into the new commit folder
    foreach my $file (glob "$index_dir/*") {
        my $file_name = $file;
        $file_name =~ s/$index_dir\///;
        copy_file($file, "$commit_dir/$file_name");
    }

    # Add commit to log file
    add_to_log($commit_id, $message);

    print "Committed as commit $commit_id\n";
}

# Compare files in previous commit to files in commit
# to see if they have been changed or not
sub check_unchanged {
    my ($file, $cur_dir, $prev_dir) = @_;

    # Check to see if the file-to-add is part of the previous commit
    if (file_exists("$prev_dir/$file")) {
        
        my $src_file = "$cur_dir/$file";
        # If current directory is the main directory, just use $file when comparing
        if ("$cur_dir" eq "*") {
            $src_file = "$file";
        }

        if (is_file_same("$src_file", "$prev_dir/$file")) {
            return 1;
        }
    }
    return 0;
}

# Causes all the files already in the index to have their contents
# from the current dictionary added to the index before the commit
sub update_index {
    my () = @_;
    my $index_dir = ".legit/.git/index";

    my $removing = 0;

    foreach my $findex (glob "$index_dir/*") {
        my $file_name = $findex;
        # Gets the file name without the path before it
        $file_name =~ s/$index_dir\///;
        if (file_exists($file_name)) {
            # Copy file from current diirectory to the index
            copy_file($file_name, $findex);
        } else {
            remove_file($findex);
            $removing++;
        }
    }
    if ($removing > 0) {
        create_index_delete($removing);
    }
}

# Subroutine that takes the user inputted message
# and adds it to a file inside the corresponding commit folder
sub write_commit_message {
    my ($commit_dir, $message) = @_;
    open MESSAGE_FILE, ">", "$commit_dir/.message" or die;
    print MESSAGE_FILE "$message";
    close MESSAGE_FILE; 
}

# Adds the new commit id and message to the log
# file every time a new commit is entered
sub add_to_log {
    my ($id, $message) = @_;
    my $log_file = ".legit/.git/log";
    my $temp_file = ".legit/.git/temp";
    # Copy lines from old log into temp log file
    copy_file($log_file, $temp_file);

    # Add the new message to the top of the file
    my $string = "$id $message\n";
    open LOG_FILE, ">", $log_file or die;
    print LOG_FILE $string;

    # Append the rest of the old messages to the new file
    open TEMP, "<", $temp_file or die;
    while (my $line = <TEMP>) {
        print LOG_FILE "$line";
    }
    close LOG_FILE;
    close TEMP;

    # Remove the temporary file
    unlink $temp_file;
}

# Subroutine that prints out all the lines in selected file
sub print_file {
    my ($file) = @_;
    open FILE, "<", $file or die;
    while (my $line = <FILE>) {
        print "$line";
    }
    close FILE;
}

# Checks if the selected directory/folder is empty or not
# Returns the number of files in selected directory/folder
sub is_folder_empty {
    my ($dir) = @_;
    opendir my $directory, $dir or die "$dir is not a directory";
    # Doesn't count the two hidden files (. and ..)
    my $files = grep { ! /^\.{1,2}/ } readdir $directory;
    return $files;
}

# Checks to see if the commit message is valid
# It is invalid if it contains nothing or all spaces
sub check_commit_message {
    my ($message) = @_;
    if ($message eq "" || $message =~ /^\s*$/) {
        print_commit_usage();
    }
}

# ---------------------------------------------------------------------------------------------#
#                                  Initialising directories                                    #

# Creates a new repo called .legit in current directory
# and also creates other initial directories and files
sub initialise_repo {
    my () = @_;
    my $repo = ".legit";
    mkdir $repo;

    # Create a hidden sub-directory to store everything needed by legit.pl
    my $subdir = ".git";
    mkdir "$repo/$subdir";
    # Directory to store all files that are about to be committed
    my $index = "index";
    mkdir "$repo/$subdir/$index";
    # Directory that stores all of the commits that have been committed
    my $commits = "commits";
    mkdir "$repo/$subdir/$commits";
    # Text file that stores the commit ID and it's commit message
    my $log = "log";
    open LOG_FILE, ">", "$repo/$subdir/$log" or die;
    close LOG_FILE;

    print "Initialized empty legit repository in $repo\n";
}

# Make a new commit directory given it's unique id
sub initialise_commit {
    my ($id) = @_;
    my $new_commit = ".legit/.git/commits/$id";
    mkdir $new_commit;

    open MESSAGE_FILE, ">", "$new_commit/.message" or die;
    close MESSAGE_FILE;
}

# ---------------------------------------------------------------------------------------------#
#                                   Usage Print Subroutines                                    #

# Function that prints the correct usage for legit.pl
sub print_usage {
    my () = @_;
    print STDERR "Usage: legit.pl <command> [<args>]\n\n";
    print STDERR "These are the legit commands:\n";
    print STDERR "   init       Create an empty legit repository\n";
    print STDERR "   add        Add file contents to the index\n";
    print STDERR "   commit     Record changes to the repository\n";
    print STDERR "   log        Show commit log\n";
    print STDERR "   show       Show file at particular state\n";
    print STDERR "   rm         Remove files from the current directory and from the index\n";
    print STDERR "   status     Show the status of files in the current directory, index, and repository\n";
    print STDERR "   branch     list, create or delete a branch\n";
    print STDERR "   checkout   Switch branches or restore current directory files\n";
    print STDERR "   merge      Join two development histories together\n";
}

# Prints message if user inputs incorrect commands
# when using the commit function
sub print_commit_usage {
    print STDERR "usage: legit.pl commit [-a] -m commit-message\n";
    exit 1;
}

sub print_show_usage {
    print STDERR "usage: legit.pl show <commit>:<filename>\n";
    exit 1;
}

sub print_rm_usage {
    print STDERR "usage: legit.pl rm [--force] [--cached] <filenames>\n";
    exit 1;
}

sub print_log_usage {
    print STDERR "usage: legit.pl log\n";
    exit 1;
}

sub print_add_usage {
    print STDERR "usage: legit.pl add <filenames>\n";
    exit 1;
}

# ---------------------------------------------------------------------------------------------#

main();