use 5.022;

# if (defined(my $line = <>))
# {
# 	chomp($line);
# 	print "It was $line that I saw!\n";
# }

# my @array = ("a\n","b\n","c\n");
# print @array;
# print "@array";

# printf "%g, %g, %g\n", 5/2, 51/17, 51**17;

if(!open PASSWD, "/etc/passwd")
{
	die "How did you get logget in?($!)";	#括号单纯只是输出括号而已
}
while(<PASSWD>){		#就像<STDIN>一样使用
	chomp;
	......
}