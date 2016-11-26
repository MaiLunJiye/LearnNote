#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;
use 5.022;

#foreach (qw(+ - * /)){
    #my $res = eval "2 $_ 2";
    #say "2 $_ 2 = $res";
#}

eval "5/";
warn $@ if $@;
