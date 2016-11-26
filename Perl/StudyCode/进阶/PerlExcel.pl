#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use 5.022;

use Spreadsheet::WriteExcel;
my $workbook = Spreadsheet::WriteExcel->new('perl.xls');
my $worksheet = $workbook->add_worksheet();

my $red_background = $workbook->add_format(
    color => 'white',
    bg_color => 'red',
    bold => 1,
);

my $bold = $workbook->add_format(
    bold => 1,
);

$worksheet->write(0,0, 'Colored cell', $red_background);
$worksheet->write(0,1,'bold cell',$bold);

