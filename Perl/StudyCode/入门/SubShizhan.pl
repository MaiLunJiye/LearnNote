use 5.022;

my $Line = "\n------------------------------\n";
print $Line;

sub total{
	my $sum;
	foreach (@_){
		$sum += $_;
	}
	$sum;
}

my @fred = qw/1 3 5 7 9/;
my $fred_total = total(@fred);
print "the total of \@fred is $fred_total.\n";
print "Enter some numbers on separate lines: ";
my $user_total = total(<STDIN>);
print "The total of those numbers is $user_total.\n";

#############################
print $Line;
print total 1..1e3;


###################################
print $Line;

sub above_average{
	my $avg;
	my @result;
	foreach (@_)
	{
		$avg+=$_;
	}

	$avg /=@_;
	foreach (@_)
	{
		if($_ > $avg)
		{
			push @result,$_;
		}
	}
	@result;
}

my @ff = above_average(1..10);
print "\@ff is @ff\n";
print "(Should be 6 7 8 9 10)\n";
my @bb = above_average(100, 1..10);
print "\@bb is @bb\n";
print "(Should be just 100)\n";

##############################
print $Line;
sub greet{
	state $last_name = "none";
	print "welcome $_[0], $last_name befort you\n";
	$last_name = $_[0];
}

greet("fred");
greet("bar");
greet("wilj");
greet("ffff");


#################################
print $Line;
sub greet_array{
	state @comearray;
	print "welcome $_[0], @comearray befort you\n";
	push @comearray,$_[0];
}

greet_array("fred");
greet_array("bar");
greet_array("wilj");
greet_array("ffff");