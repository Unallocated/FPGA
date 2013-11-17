#!/usr/bin/perl

use strict;

use Data::Dumper;

sub usage {
	print "Usage: $0 <inputAssemblyFile>\n\n";
	print "\tinputAssemblyFile => Path to the input file\n\n";
	exit(1);
}

my $inputFile = shift || usage();

if(! -f $inputFile){
	print "Error: Input file '$inputFile' does not exist.\n";
	usage();
}

if(! -r $inputFile){
	print "Error: Input file '$inputFile' is not readable.\n";
	usage();
}

my $opcodes = {};

addOpcode("noop", 0, 1);
addOpcode("mova", 1, 2);
addOpcode("movaf", 2, 3);
addOpcode("jmp", 3, 3);
addOpcode("porta", 4, 2);
addOpcode("adda", 5, 2);
addOpcode("suba", 6, 2);
addOpcode("lsla", 7, 2);
addOpcode("lsra", 8, 2);
addOpcode("mula", 9, 2);
addOpcode("lrla", 10, 2);
addOpcode("lrra", 11, 2);
addOpcode("movfa", 12, 3);
addOpcode("janez", 13, 3);
addOpcode("jane", 14, 4);
addOpcode("janef", 15, 5);
addOpcode("addca", 16, 2);
addOpcode("call", 17, 3);
addOpcode("ret", 18, 1);
addOpcode("addaf", 19, 3);
addOpcode("subaf", 20, 3);
addOpcode("multaf", 21, 3);
addOpcode("xora", 22, 2);
addOpcode("ora", 23, 2);
addOpcode("anda", 24, 2);
addOpcode("nora", 25, 2);
addOpcode("xnora", 26, 2);
addOpcode("nanda", 27, 2);
addOpcode("xoraf", 28, 3);
addOpcode("oraf", 29, 3);
addOpcode("andaf", 30, 3);
addOpcode("noraf", 31, 3);
addOpcode("xnoraf", 32, 3);
addOpcode("nandaf", 33, 3);
addOpcode("jagt", 34, 4);
addOpcode("jagtf", 35, 5);
addOpcode("push", 36, 2);
addOpcode("pop", 37, 2);

my $largestOpcode = 0;
foreach (keys(%{$opcodes})){
	if(length($_) > $largestOpcode){
		$largestOpcode = length($_);
	}
}

open(FH, "<", $inputFile) or die ("Could not open input file '$inputFile'.  Details: $!");

my @lines;
while(<FH>){
	chomp;
	s/\s{2,}/ /;
	s///g;
	s/[\s\t]*[(--)|(;)].+//g;
	push(@lines, $_);
}
close(FH);

my %variables;

my $lineNumber = 1;
my $pos = -1;

my @incedLines;

foreach(@lines){
	$pos++;
	if(/^inc (\w+\.inc)$/){
		print "Including file $1\n";
		if(! -f $1){
			print "Error: Include file '$1' does not exist.\n";
			exit(1);
		}elsif(! -r $1){
			print "Error: Could not read include file '$1'.\n";
			exit(1);
		}

		open(IN, "<", $1) or die ("Could not open include file '$1'.  Details: $!");
		my @incLines = <IN>;
		chomp(@incLines);
		push(@incedLines, @incLines);
	}else{
		push(@incedLines, $_);
	}
}

#print "\n------- ELABORATED LINES -------\n";
#foreach (@incedLines){
#	print "$_\n";
#}
#print "------- END ELABORATED LINES --------\n\n";

@lines = @incedLines;

foreach(@lines){
	if(/^def/){
		my ($varName, $address) = /^def\s(.+?)\s(.+?)$/;
		if(isValidOpcode($varName)){
			print "Error: Invalid variable name '$varName' at line $lineNumber near instruction '$_'\n";
			exit(1);
		}
		
		if(exists($variables{$varName})){
			print "Error: Redefinition of variable '$varName' at line $lineNumber.\n";
			exit(1);
		}

		if($address !~ /^0x[a-fA-F0-9]{2}$/ && $address !~ /^0x[a-fA-F0-9]{4}$/ && $address !~ /^[0-1]{16}$/){
			print "Error: Invalid memory location '$address' at line $lineNumber near instruction '$_'\n";
			exit(1);
		}
		
		if($address =~ /^0x[a-fA-F0-9]{4}$/){
			$address =~ /^0x([a-fA-F0-9]{2})([a-fA-F0-9]{2})/;
			$variables{$varName} = sprintf("%08b %08b", hex($1), hex($2));
		}else{
			$address =~ /^0x([a-fA-F0-9]{2})/;
			$variables{$varName} = sprintf("%08b",hex($1));
		}

	}
	$lineNumber++;
}

#print Dumper \%variables;

$lineNumber = 1;
my @newLines;

foreach(@lines){
	foreach my $variable (keys(%variables)){
		if(! /^def/ && ! /\:/){
			if(/ $variable / || / ${variable}$/){
				my $var = $variables{$variable};
				s/ $variable/ $var/;
				last;
			}
		}
	}
	push(@newLines, $_);
	$lineNumber++;
}

my @newLines2;
$lineNumber = 0;
my %labels;

my $pc = 0;
foreach (@newLines){
	if(/^([a-zA-Z0-9]+)\:/){
		if(exists($labels{$1})){
			print "Error: Duplicate label '$1' at line number '$lineNumber'.\n";
			exit(1);
		}
		$labels{$1} = $pc;
	}elsif(/^def/){

	}elsif(/^[\s\t]*$/){

	}else{
		/^[\s\t]*?([a-zA-Z0-9]+)[\s\t]*/;
		if(! isValidOpcode($1)){
			print "Error: Found an invalid opcode '$1' at line number '$lineNumber' near '$_'.\n";
			exit(1);
		}

		$pc += getBytes($1);
	}

	$lineNumber++;
}

foreach (@newLines){
	if(/^[a-zA-Z0-9]+\:/ || /^def/){
		next;
	}

	foreach my $label (keys(%labels)){
		if($_ =~ /${label}$/ || $_ =~ /$label/){
			my $replacement = sprintf("%08b %08b", (($labels{$label} & 0xff00) >> 8), $labels{$label} & 0xff);
			s/$label/$replacement/;
			last;
		}
	}

	s/^[\s\t]+//g;

	push(@newLines2, $_);
}

$lineNumber = 0;
my $print;
my $pos = 0;
print Dumper @newLines2;
foreach(@newLines2){
	$lineNumber++;
	if(/^$/){
		next;
	}

	my @parts = split(' ');
	my $opcode = shift(@parts);
	if(! isValidOpcode($opcode)){
		print "Error: Opcode '$opcode' is not valid at line '$lineNumber'\n";
		exit(1);
	}

	if($#parts + 2 != getBytes($opcode)){
		print "Error: Opcode '$opcode' needs '".(getBytes($opcode)-1)."' bytes after the opcode.  Found '".($#parts+1)."' bytes at line '$lineNumber'\n";
		exit(1);
	}
	my $orig = $pos;
	#my $line = "opcodes.$opcode,";
	#$print .= "\t\topcodes.$opcode,";
	$print .= sprintf("\t\topcodes.%-${largestOpcode}s",$opcode.","); 
	$pos++;
	for($a = 0; $a <= $#parts; $a++){
		my $arg = $parts[$a];
		if($arg =~ /^0x([a-fA-F0-9]{2})$/){
			$print .= "x\"$1\",";
		}elsif($arg =~ /^([0-1]{8})$/){
			$print .= sprintf("x\"%02x\",", oct("0b".$1));
		}else{
			print "Error: Invalid argument '$arg' at line number '$lineNumber'\n";
			exit(1);
		}
		$pos++;
	}
	$print .= "\n";
	#$print .= " --  $orig -> ".($pos-1)."\n";
	#print "$line\n";
}

#$print =~ s/, (-- \d+ -> \d+\n)$/$1/;
$print =~ s/[\r\n]+$//;
$print =~ s/,[\s\t\r\n]+$//;

print "\n--- COPY AND PASTE INTO VHD FILE ---\n";
print "\tconstant program : program_type := (\n";
print "$print\n";
print "\t);\n";
print "--- END OF COPY AND PASTE SECTION ---\n";

#print Dumper \%labels;

sub getBinary {
	my $_ = shift;

	if(/^0x/){
		s/^0x//;
		return sprintf("%08b", hex($_));
	}elsif(/^[a-f0-9A-F]{8}$/){
		return $_;
	}
}

sub isValidArg {
	my $_ = shift;
	return (/^0x[a-f0-9A-F]{2}$/ || /^[0-1]{8}$/);
}

sub isValidOpcode {
	my $opcode = shift;

	return exists($opcodes->{$opcode});
}

sub addOpcode {
	my ($code, $index, $bytes) = @_;

	if(exists($opcodes->{$code})){
		die("Opcode '$code' already exists!");
	}else{
		$opcodes->{$code} = { index => $index, bytes => $bytes };
	}
}

sub getIndex {
	my $opcode = shift;

	return $opcodes->{$opcode}->{'index'};
}

sub getBytes {
	my $opcode = shift;

	return $opcodes->{$opcode}->{'bytes'};
}
