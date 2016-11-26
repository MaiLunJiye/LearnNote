use strict;

my $question = 1;
print "\n------question$question--------\n"; $question++;
my @array = <STDIN>;
print reverse @array;


print "\n------question$question--------\n"; $question++;
my @name_list = qw/fred betty barney dino wilma pebbles bamm-bamm/;
@array = <STDIN>;
foreach (@array){
	print $name_list[$_]," ";
}

print "\n------question$question--------\n"; $question++;
@array = <STDIN>;

my @sort = sort @array;
print "-------\n";
print @sort;
chomp @sort;
print "@sort";