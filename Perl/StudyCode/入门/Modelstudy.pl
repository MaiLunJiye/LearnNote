use 5.022;
use File::Basename;
use File::Spec qw//;

##模块学习， File::Basename
# print "Please input a file name\n";
# chomp(my $old_name = <STDIN>);
# my $dirname = dirname $old_name;
# my $basename = basename $old_name;

# $basename =~ s/^/not/;
# my $new_name = "$dirname/$basename";

# File::Basename::rename($old_name, $new_name)
# 	or warn "Can't rename '$old_name' to '$new_name':$!";

# say $new_name;


# ##模块学习 File::Spec
# print "Please input a file name\n";
# chomp(my $old_name = <STDIN>);
# my $dirname = dirname $old_name;
# my $basename = basename $old_name;

# $basename =~ s/^/not/;

# my $new_name = File::Spec->catfile($dirname,$basename);##面向对象的模块调用 ->


# ##模块学习 Path::Class
# my $dir = dir( qw/Users fred lib/ );
# my $subdir = $dir->subdir('perl5');		#Users/fred/lib/perl5
# my $parent = $dir->parent;				#Users/fred
# my $windir = $dir->as_foreign('Win32');	#Users\fred\lib


# ##模块学习CGI.pm模块  需要安装
# #!/usr/bin/perl
# use CGI qw/:all/;
# say header("text/plain");
# foreach $param( param() ) {
# 	print "$param: ".param($param)."\n";
# }

# ##时间模块
# use Time::Piece;
# my $t = localtime;
# print 'The month is '. $t->month."\n";	#输出月份
