#!/usr/bin/perl

use strict;

use constant OPCODE_PREFIX => "opcodes.";
use constant PROGRAM_TYPE  => "program_type";
use constant PROGRAM_NAME  => "program";

my $opcodes = {
	'noop'  => [0, 0],
	'mova'  => [1, 1],
	'movaf' => [2, 2],
	'jmp'   => [3, 2],
	'porta' => [4, 1],
	'adda'  => [5, 1],
	'suba'  => [6, 1],
	'lsla'  => [7, 1],
	'lsra'  => [8, 1],
	'mula'  => [9, 1],
	'lrla'  => [10, 1],
	'lrra'  => [11, 1],
	'movfa' => [12, 2],
	'janez' => [13, 2],
	'jane'  => [14, 3],
	'janef' => [15, 4],
	'addca' => [16, 1]
};

my %usedOpcodes;

my $file = shift || die("No input file specified");
my $fh;
open($fh, "<", $file);
my @program = <$fh>;
close($fh);

my $vhdl = "\tconstant ".PROGRAM_NAME." : ".PROGRAM_TYPE." := (\n";


for($a = 0; $a <= $#program; $a++){
	chomp($program[$a]);
	if(length($program[$a]) == 0){
		next;
	}
	$program[$a] =~ s/\s+//g;
	my (@parts) = split(',', $program[$a]);
	
	my $opcode = $parts[0];
	if(! exists($opcodes->{$opcode})){
		print "Error: Opcode '$opcode' is not valid.\n";
		exit(1);
	}

	$usedOpcodes{$opcode}++;

	$vhdl .= "\t\t".OPCODE_PREFIX."$opcode,\n";

	if($#parts != $opcodes->{$opcode}[1]){
		print STDERR "Error: Expected ".$opcodes->{$opcode}[1]." extra arguments at line ".($a+1).".  Found ".$#parts." arguments";
		exit(1);
	}



	for($b = 1; $b <= $opcodes->{$opcode}[1]; $b++){
		my $arg = $parts[$b];
		
		if($arg =~ /^\d{8}$/){
			# do nothing
		}elsif($arg =~ /^0x[a-fA-F0-9]{2}$/){
			$arg =~ s/0x//g;
			$arg = sprintf("%08b", hex($arg));
		}else{
			print STDERR "Error: Argument \"$arg\" at line ".($a+1)." is not valid\n";
			exit(1);
		}
		$vhdl .= "\t\t\"$arg\",\n";
	}
}

$vhdl =~ s/,\n$//g;
$vhdl .= "\n\t);";

print "Code: \n\n--------\n$vhdl\n-----\n";

print "-- Used Opcodes:\n";
foreach my $key (keys(%usedOpcodes)){
        print "--   $key ($usedOpcodes{$key})\n";
}


=head
for($a = 0; $a <= $#program; $a++){
	my $opcode = $program[$a];
	chomp($opcode);

	if(!exists($opcodes->{$opcode})){
		print STDERR "Error: Opcode \"$opcode\" at line ".($a+1)." is not valid.\n";
		exit(1);
	}

	$usedOpcodes{$opcode}++;

	$vhdl .= "\t".OPCODE_PREFIX."$opcode,\n";

	for($b = 1; $b <= $opcodes->{$opcode}[1]; $b++){
		if($a+$b > $#program){
			print STDERR "Error: Program ended abruptly.\n";
			exit(1);
		}

		my $arg = $program[$a+$b];
		chomp($arg);

		if($arg =~ /^\d{8}$/){
			# do nothing.  already in 8 bit format
		}elsif($arg =~ /^0x[a-fA-F0-9]{2}$/){
			$arg =~ s/0x//g;
			$arg = sprintf("%08b", hex($arg));
		}else{
			print STDERR "Error: Argument \"$arg\" at line ".($a+$b+1)." is not valid\n";
			exit(1);
		}

		$vhdl .= "\t\"$arg\",\n";
	}
	$a += $opcodes->{$opcode}[1];

}

$vhdl =~ s/,\n$//g;
$vhdl .= "\n);";

print "Code: \n\n--------\n$vhdl\n-----\n";

print "-- Used Opcodes:\n";
foreach my $key (keys(%usedOpcodes)){
	print "--   $key ($usedOpcodes{$key})\n";
}
