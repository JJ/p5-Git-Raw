#!/usr/bin/env perl

use strict;
use warnings;
use CPAN;
use Env qw(@PATH);
use File::Basename qw(dirname);

print "Perl is at: $^X", "\n";

# Ensure this perl is on the path
unshift @PATH, dirname($^X);

foreach (@ARGV) {
	print "Installing '$_'", "\n";
 	CPAN::Shell -> rematein('notest', 'install', $_);
}

exit(0);
