#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use 5.022;

##P34 
#sub check_require_items {
    #my $who = shift;
    #my %whos_items = map {$_,1} @_;
    
    #my  @required = qw(preserver sunscreen water_bottle jacket);

    #for my $item (@required){
        #print "$who is missing $item.\n" unless ( $whos_items{$item})
    #}
#}

#my @gilligan = qw( red_shirt hat luck_socks water_bottle);
#check_require_items('gilligan', @gilligan);
#==========================================

##p38
#my @skipper = qw(blue_shirt hat jacket preserver sunscreen);
#&check_require_items("The Skipper", \@skipper);

#sub check_require_items{
    #my $who = shift;
    #my $items = shift;

    #my %whos_items = map {$_,1} @{$items};  # 指代整个数组

    #my @required = qw(preserver sunscreen water_bottle jacket);

    #for my $item (@required) {
        #unless ($whos_items{$item}) {
            #say "$who is missing $item";
        #}
    #}

#}
#==================================================

#p
#40
sub check_require_items{
    my $who = shift;
    my $items = shift;
    my @required = qw(preserver sunscreen water_bottle jacket);

    for my $item (@required) {
        unless (grep $item eq $_, @$items) { # @$items 省略了括号
            say "$who is missing $item";
        }
    }

}


#==================================================
