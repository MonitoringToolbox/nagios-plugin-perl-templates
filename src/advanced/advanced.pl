#!/usr/bin/env perl

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# This Nagios check script serves as a more sophisticated example that uses        #
# utility functions to guarantee the accuracy of the output and exit code.         #
#                                                                                  #
# Unlike the basic version, this one utilizes command-line parameters to override  #
# the default hard-coded values, thereby enabling more advanced or portable        #
# scripting. Nevertheless, we also supply a basic version suitable for checks that #
# don't demand parameters.                                                         #
# -------------------------------------------------------------------------------- #

use strict;
use warnings;

use File::Basename;
use Getopt::Long;

# -------------------------------------------------------------------------------- #
# Flags                                                                            #
# -------------------------------------------------------------------------------- #
# A set of global flags that we use for configuration.                             #
# -------------------------------------------------------------------------------- #

my $ALLOW_ZERO_INPUT = 1;            # Do we require any user input ?

# -------------------------------------------------------------------------------- #
# Main()                                                                           #
# -------------------------------------------------------------------------------- #
# This function is where you add all of the check related code. You can define     #
# additional functions and call them as needed.                                    #
#                                                                                  #
# For this template we simply generate a random number and demonstrate how to      #
# call the core functions to handle the various states. Real tests will be more    #
# complex and involved but should follow the same basic pattern.                   #
# -------------------------------------------------------------------------------- #

sub main {
    my ($flat_options) = @_;
    my %options = %$flat_options;

    my $test_value = 1 + int rand(100);

    if ($test_value >= $options{"critical_level"}) {
        handle_critical("Test Value = ${test_value}");
    } elsif ($test_value >= $options{"warning_level"}) {
        handle_warning("Test Value = ${test_value}");
    } elsif ($test_value >= 0) {
        handle_ok("Test Value = ${test_value}");
    } else {
        handle_unknown("Test Value = ${test_value}");
    }
}

# -------------------------------------------------------------------------------- #
# Usage (-h parameter)                                                             #
# -------------------------------------------------------------------------------- #
# This function is used to show the user 'how' to use the script.                  #
# -------------------------------------------------------------------------------- #

sub usage {
    my ($critical_level, $warning_level) = @_;
    my ($name, $path, $suffix) = fileparse( $0, qr{\.[^.]*$} );

    print <<EOF;
$name$suffix [-h|--help] [-c|--critical] [-w|--warning]
    --help, -h          : Print this help, then exit
    --critical, -c      : Critical level [Default: $critical_level]
    --warning, -w       : Warning level [Default: $warning_level]
EOF
    exit 0;
}

# -------------------------------------------------------------------------------- #
# Process Arguments                                                                #
# -------------------------------------------------------------------------------- #
# This function handles the input from the command line. In this template, we've   #
# included an illustration of how to retrieve and process fresh warning and        #
# critical values. All the inputs are stored in the 'options' hash and then passed #
# on to main().                                                                    #
#                                                                                  #
# You can add as many fresh inputs as your check requires.                         #
# -------------------------------------------------------------------------------- #

sub process_arguments {
    my $critical_level = 90;
    my $warning_level = 75;
    my $show_help = 0;

    my %options;

    if (($ALLOW_ZERO_INPUT == 0) && (!@ARGV)) {
        handle_unknown("No parameters given");
    }

    GetOptions (
        "help" => \$show_help,
        "critical=i" => \$critical_level, 
        "warning=i"   => \$warning_level
    );

    usage($critical_level, $warning_level) if ($show_help);

    if ($warning_level >= $critical_level) {
        handle_unknown("Warn level MUST be lower than Critical level");
    }

    $options{"critical_level"} = $critical_level;
    $options{"warning_level"} = $warning_level;

    main(\%options);
}

# -------------------------------------------------------------------------------- #
# STOP HERE!                                                                       #
# -------------------------------------------------------------------------------- #
# The functions listed below are integral to the template and do not necessitate   #
# any modifications to use this template. If you intend to make changes to the     #
# code beyond this point, please make certain that you comprehend the consequences #
# of those alterations!                                                            #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Handle OK                                                                        #
# -------------------------------------------------------------------------------- #
# If provided with a message, this function will show it with the 'OK' prefix and  #
# subsequently terminate the script with the requisite exit code of 0.             #
# -------------------------------------------------------------------------------- #

sub handle_ok {
    my $message = shift || '';

    print("OK - ${message}\n") unless ($message eq '');
    exit 0;
}

# -------------------------------------------------------------------------------- #
# Handle Warning                                                                   #
# -------------------------------------------------------------------------------- #
# If provided with a message, this function will show it with the 'WARNING' prefix #
# and subsequently terminate the script with the requisite exit code of 1.         #
# -------------------------------------------------------------------------------- #

sub handle_warning {
    my $message = shift || '';

    print("WARNING - ${message}\n") unless ($message eq '');
    exit 1;
}

# -------------------------------------------------------------------------------- #
# Handle Critical                                                                  #
# -------------------------------------------------------------------------------- #
# If provided with a message, this function will show it with the 'CRITICAL'       #
# prefix and subsequently terminate the script with the requisite exit code of 2.  #
# -------------------------------------------------------------------------------- #

sub handle_critical {
    my $message = shift || '';

    print("CRITICAL - ${message}\n") unless ($message eq '');
    exit 2;
}

# -------------------------------------------------------------------------------- #
# Handle Unknown                                                                   #
# -------------------------------------------------------------------------------- #
# If provided with a message, this function will show it with the 'UNKNOWN' prefix #
# and subsequently terminate the script with the requisite exit code of 3.         #
# -------------------------------------------------------------------------------- #

sub handle_unknown {
    my $message = shift || '';

    print("UNKNOWN - ${message}\n") unless ($message eq '');
    exit 3;
}

# -------------------------------------------------------------------------------- #
# The Core                                                                         #
# -------------------------------------------------------------------------------- #
# This is the central component of the script.                                     #
# -------------------------------------------------------------------------------- #

process_arguments

# -------------------------------------------------------------------------------- #
# End of Script                                                                    #
# -------------------------------------------------------------------------------- #
# This is the end - nothing more to see here.                                      #
# -------------------------------------------------------------------------------- #
