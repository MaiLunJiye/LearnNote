use 5.010;


# #last 跳出循环， next 强制进入下个循环  redo 重新进行本次循环
# for(1..10)
# {
# 	print "Iteration number $_ .\n\n";
# 	print "Please choose: last, next , redo, or none of the above\n";
# 	chomp( my $choice = <STDIN>);
# 	print "\n";
# 	last if $choice =~ /last/i;
# 	next if $choice =~ /next/i;
# 	redo if $choice =~ /redo/i;
# 	print "That wasn't any of the choices... onward!\n\n";
# }

# say "That's all , folks!";


# #猜数字游戏
# my $num = int(1+rand 10);
# while(<>)
# {
# 	(/(quit|exit|^\s+$)/i) ? last:
# 	($_==$num)? ((say "right")&&last):	#利用部分操作符完成两个操作
# 	($_<$num)? (say "too low"):
# 			(say "too heigth");
# }


# #猜数字游戏  展示调试信息版
# # my $check=$ENV{DEBUG} // 1;
# my $check;
# my $num = int(1+rand 10);
# while(<>)
# {
# 	(/(quit|exit|^\s+$)/i) ? last:
# 	($_==$num)? ((say "right")&&last):	#利用部分操作符完成两个操作
# 	($_<$num)? (say "too low"):
# 			(say "too heigth");

# 	$check && say "-----------check..... num is $num\n";
# }


##展示环境变量  undef 的输出 "(undefined)"
# $ENV{ZERO} = 0;
# $ENV{EMPTY} = 0;
# $ENV{UNDEFINED} = undef;

# my $longest = 0;
# foreach my $key (keys %ENV)
# {
# 	my $key_length = length($key);
# 	$longest = $key_length if $key_length>$longest;
# }

# foreach my $keys (sort keys %ENV)
# {
# 	printf "%-${longest}s  %s\n", $keys, $ENV{$keys}//"(undefined)";
# }