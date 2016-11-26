# use 5.022;
# my $name = 'Fred or Barney';
# if( $name =~ m{(?<name1>\w+) (?:and|or) (?<name2>\w+)})
# {
# 	say "I saw $+{name1} and $+{name2}";
# }


# use 5.022;

# my $names = 'Fred Flintstone and Wilma Flintstone';
# if ( $names =~ m/(?<last_name>\w+) and \w+ \g{last_name}/)
# {
# 	say "I saw $+{last_name}";
# }


use 5.022;
while(<>)
{
	chomp;
	if (/自己的表达式/) {
		say "Match: $`<$&>$'";
	} else {
		say "No match: $_";
	}
}