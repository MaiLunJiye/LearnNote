use strict;
use 5.010;

sub max_two{
	$_[0]>$_[1] ? $_[0]:$_[1];
}

sub pLine{
	print "\n++++++++++++++++++++++++++++++++++++++++++\n";
}


print &max_two(12,53),"\n";
print &max_two(53,12),"\n";

&pLine;
my @name = qw/ fred barney betty dino wilma pebbles bamm-bamm/;
my $result = &which_element_is("dino", @name);

sub which_element_is {
	my($what, @array) = @_;
	foreach (0..$#array) {
		if($what eq $array[$_])
		{
			return $_;
		}
	}
	-1;		
}

pLine;	

sub list_from_fred_to_barney {
	$_[0]<$_[1] ? $_[0]..$_[1] : reverse $_[1]..$_[0];
}
my @c = list_from_fred_to_barney(11,6);
my $t = list_from_fred_to_barney(11,6);
my $v = scalar list_from_fred_to_barney(11,6);
print @c," ",$t," ",$v," ",scalar @c,"\n";
$v = @c;
print $v;

pLine;
sub marine{
	state $n = 0;	#持久变量
	$n++;
	print "Hello,sailor number $n!\n";
}
marine;
marine;
marine;

pLine;