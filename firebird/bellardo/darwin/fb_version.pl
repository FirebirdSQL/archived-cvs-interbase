#!/usr/bin/perl

#use strict;
my $line;
my $cmd = "source/interbase/bin/gpre -Z";
$cmd = $ARGV[0] if ($#ARGV >= 0);

open(JOHN, "$cmd 2>/dev/null |");
if (!defined(JOHN))
{
    print "UNKNOWN VERSION";
    exit 0;
}

my $vers = "UNKNOWN";
while ($line = <JOHN>)
{
    chomp($line);
    $vers = $line;
}
close (JOHN);

$vers =~ s/\A[\t ]*gpre version //g;
$vers =~ s/\A[\t ]*or more correctly //g;

print "$vers";
