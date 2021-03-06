#!/usr/bin/perl -w
## Copyright (C) 20xx by me \n


# #贪婪与非贪婪量词
# my $senters = "<body>hello everyone</body>,<body>i like you</body>";
# my $tanlan = ($senters =~ s{<body>(.*)</body>}[$1]igr);
# my $feitanlan = ($senters =~ s{<body>(.*?)</body>}[$1]igr);
# say $tanlan;
# say $feitanlan;



# # 单个文件的修改
# chomp(my $date = localtime);
# $^I = ".bak";

# while(<>)
# {
# 	s/^Author:.*/Author: Simqin H. xiong/;
# 	s/^Phone:.*\n//;
# 	s/^Date:.*/Date: $date/;
# 	print $_;
# }


# #添加版权声明
# $^I = ".bak";
# while(<>)
# {
# 	if(/\A#!/) {	#判断是否是开头一行
# 		$_ .= '##Copyright (C) 20xx by me \n';	#添加声明
# 	}
# 	print;
# }
# #使用时候 后面加上 文件路径



#第十章 最后的练习
#版权声明进阶：自动判断 是否重复声明

#先把每个 文件名字 当做哈希的键保存
my %do_these;
foreach (@ARGV) {		#文件名字保存在这个数组中
	$do_these{$_} = 1;
}

while(<>)		#钻石输入符号是读取@AEGV的
{
	if(/\A## Copyright/) {	#如果检查到已经 声明版权了，就去掉对应哈希
		delete $do_these{$ARGV};
	}
}

@ARGV = sort keys %do_these;	#去掉的哈希不会在这个函数返回，返回的都是 没声明的哈希
							#赋值给@ARGV可以让 钻石操作符 再次读取
$^I = '.bak';		#备份
while(<>)
{
	if(/\A#!/) {
 		$_ .= '## Copyright (C) 20xx by me \n';	#添加声明
	}
	print;
}