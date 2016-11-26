#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

use 5.022;

say " 1 .......................";
my @all_file = glob '/etc/*';

my @result = grep { -s $_  < 1000} @all_file;
say $#all_file;
say $#result;

say "================";

@result = map {'    '.$_."\n"} qw( aaaa bbbbbb dddddd); 
say @result;

say " 2 .........................";

while(my $pat = <stdin>)
{
        @result = grep eval"m$pat",@all_file;
        last if $@;
        say @result;
}
say "end";
