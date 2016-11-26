use strict;
my @as = qw/aa bb cc/;
print 24+@as;
print "\n";
print reverse sort @as;
print "\n";
print @as;
print "\n";
print "@as";
print "\n";

print "-------------------\n";
my $hcc = 6;
@as = $hcc;
print "@as\t".@as;

print "-------------------\n";
my @rocks = qw< talc qure fwef ddg>;
print "How many rocks do you have?\n";
print "I have ",@rocks," rocks!\n";
print "I have ",scalar @rocks," rocks!\n";
print "I have scalar @rocks rocks!\n";
print "I have scalar(@rocks) rocks!\n";