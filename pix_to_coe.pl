#!/usr/bin/perl

use strict;
use warnings;

undef $/;

my $file = shift || die("No input file specified");

my $fh;
open($fh, "<", $file) or die($!);
binmode($fh);


my @data = map unpack('H2', $_), split //, <$fh>;


my $width = hex($data[0].$data[1]);
my $height = hex($data[2].$data[3]);
my $dummy = hex($data[4].$data[5]);
$dummy = hex($data[6].$data[7]);
my $bitsPerPixel = hex($data[8].$data[9]);

print "; depth=$height\n";
print "; width=$width\n";


print "memory_initialization_radix=2;\n";
print "memory_initialization_vector=\n";

my $offset = 10;
my $bitPos = 0;
my $row = "";
while($offset <= $#data && $bitPos < ($width * $height)){
	my $length = hex($data[$offset++]);
	my $color = 0;
	for(my $b = 0; $b < $bitsPerPixel/8; $b++){
		if(hex($data[$offset]) > 128){
			$color = 1;
		}
		$offset++;
	}
	
	if($color == 1){
		for($a = 0; $a < $length; $a++){
			if(length($row) == $width){
				print "$row,\n";
				$row = "";
			}
			$row .= "0";
		}
	}else{
		for($a = 0; $a < $length; $a++){
			if(length($row) == $width){
				print "$row,\n";
				$row = "";
			}
			$row .= "1";
		}
	}
}

print "$row;";