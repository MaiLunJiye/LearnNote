use 5.022;

# $_ = "He's out bowling with Barney tonight";
# s/with (\w+)/against $1's team/;
# say $_;

# $_ = "green scaly dinosaur";
# s/(\w+) (\w+)/$2, $1/;
# s/^/huge, /;
# s/,.*een//;
# s/green/red/;
# s/\w+$/($`!)$&/;
# s/\s+(!\W+)/$1 /;
# s/huge/gigantic/;


# $_ = "Input    data\t may have   	extra whitesapce.";
# say $_;
# s/\s+/ /g;
# say $_;

# my $some_inupt = "This is a  \t      	test .\n";
# my @args = split /\s+/,$some_inupt;
# say "@args";

# my $jin = join ":",@args;
# say $jin;


$_ = "hello there, neighbor!";
my($first, $second, $third) = /(\S+) (\S+), (\S+)/;
print "$second is my $third\n";