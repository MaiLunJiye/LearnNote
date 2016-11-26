use 5.022;
#my @original_file = qw/ fred barney betty wilma pebbles dino bamm-bamm/;
#my @big_old_files;
#foreach my $filename (@original_file){
#	push my @bing_oldfiles,$filename
#		if -s $filename > 100_000 and -A $filename > 90;
#}
#
#my $timestamp = 1180630098;
#my $date = localtime $timestamp;
#say $date;


#foreach my $file (@ARGV){
#	my $attribs = &attributes($file);
#	print "'$file' $attribs.\n";
#}
#
#sub attributes {
#	my $file = shift @_;
#	return "does not exit" unless -e $file;
#	
#	my @attrib;
#	push @attrib, "readable" if -r _;
#	push @attrib, "writable" if -w _;
#	push @attrib, "executable" if -x _;
#	return "exists" unless @attrib;
#	'is '.join " and ",@attrib;
#}

my ($old_name,$old_time)
foreach(@ARGV){
	last if -e $_
	if(-M _ > -e){

	}
	
}

say "no input" unless $old_name;
say "$old_name has exist $old_time";
