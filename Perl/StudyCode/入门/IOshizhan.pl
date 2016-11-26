use autodie;
use 5.022;
use strict;

# my @array;
# while (<>)
# {
# 	push @array,$_;
# }

# while(@array){
# 	print pop @array;
# }



# my $ruler = "1234567890"x3;
# my @chararray;
# while(<STDIN>)
# {
# 	chomp;				#如果不去后面的换行，会在格式化时候 占一个字符位置
# 	push @chararray,$_;
# }
# say $ruler;
# while(@chararray)
# {
# 	printf "%20s\n",shift @chararray;
# }


# my $ruler = "1234567890"x5;
# my @chararray;
# say "Input the char wide";
# chomp (my $char_width = <STDIN>);

# while(<STDIN>)
# {
# 	chomp;				#如果不去后面的换行，会在格式化时候 占一个字符位置
# 	push @chararray,$_;
# }
# say $ruler;
# while(@chararray)
# {
# 	printf "%${char_width}s\n",shift @chararray;
# }