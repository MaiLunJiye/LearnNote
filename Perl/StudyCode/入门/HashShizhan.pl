# 9.2  perl 入门 p129

use 5.010;
use autodie;

# my %name_hash = (
# 	fred => "flintstone",
# 	barney => "rubble",
# 	wilma => "flintstone",
# );

# while(<STDIN>) {
# 	chomp;
# 	say "$_ 's family name is $name_hash{$_}";
# }




# open WORD_DOC,'<','doc2.txt';
# my %word_num_hash;
# while(<WORD_DOC>){
# 					#不知道为什么不能用chomp
# 	$word_num_hash{$_}++;
# }

# my @word_keys = sort keys %word_num_hash;

# foreach (@word_keys) {
# 	say "$_ => $word_num_hash{$_}"
# }


# my @ENV_keys = sort keys %ENV;
# foreach (@ENV_keys) {
# 	printf "%20s == %s\n",@$_,$ENV{$_};
# }


# 答案
my (@words, %count, $word);
chomp{$word = <STDIN>};
foreach $word (@words) {
	$count{$word}++;
}
foreach $word {keys %count}{
	print "$word was seen $count{$word} times.\n";
}