#!/usr/bin/perl -w

use strict;
my($testProgram,$input, $output, $expectedOutput, $cppInput, $cppProgram, $cppExpectedOutput);

if(@ARGV == 3)
{
	print "Hello\n";
	$testProgram = $ARGV[0];
	$input = $ARGV[1];
	$expectedOutput = $ARGV[2];
	
	$output = "copy" . "$expectedOutput";
	$cppProgram = "copy" . "$testProgram";
	if($input ne "/dev/null")
	{
		$cppInput = "copy" . "$input";
	}
	$cppExpectedOutput = "copy" . "exptectedOutput";
	
	if((-e $testProgram && -e $input && -e $expectedOutput) || (-e $testProgram && $input eq "/dev/null" && -e $expectedOutput))
	{
		mkdir("scratch", 0777);
		
		use File::Copy;
		
		copy("$testProgram", "$cppProgram");
		if($input ne "/dev/null")
		{
			copy("$input", "$cppInput");
		}
		copy("$expectedOutput", "$cppExpectedOutput");
		
		move("/home/dsigmund/public_html/$cppProgram","/home/dsigmund/public_html/scratch/$cppProgram");
		if($input ne "/dev/null")
		{
			move("/home/dsigmund/public_html/$cppInput", "/home/dsigmund/public_html/scratch/$cppInput");
		}
		move("/home/dsigmund/public_html/$cppExpectedOutput", "/home/dsigmund/public_html/scratch/$cppExpectedOutput");
		
		chdir("scratch");
		
		if($input ne "/dev/null")
		{
			print "Compiling...\n";
			system("g++ $cppProgram -o testProgram");
			
			print "Running...\n";
			system("./testProgram <$cppInput> $output");
		}
		else
		{
			print "Compiling...\n";
			system("g++ $cppProgram -o testProgram");
			
			print "Running...\n";
			system("./testProgram $output");
		}
		print "Results:\n";
		
		use File::Compare;
		
		if(compare ("$output", "$cppExpectedOutput") == 0)
		{
			print "Output conforms to specs!\n";
		}
		else
		{
			system("diff $output $cppExpectedOutput");
		}
		unlink("$cppProgram");
		unlink("$cppInput");
		unlink("$cppExpectedOutput");
		unlink("$output");
		unlink("$testProgram");
	}
	else
	{
		die "File not found!\n";
	}
}
else
{
	die "You Must Enter 3 Arguments!\n";
}