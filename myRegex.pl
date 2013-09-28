#!/usr/bin/perl -w

use strict;
my ($str, $pat, $cons, $answer, $word, $wordfile);

$wordfile = "/usr/share/dict/words";

$pat = 
"^[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[aA][b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[eE][b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[iI][b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[oO][b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*[uU][b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]*\$";


print "This is a Regular Expression program.\n";
print ("The current pattern is: ".$pat."\n");
print ("Would you like to change it (y\\n).\n");

print "> ";
$answer = <STDIN>;
chomp($answer);

if($answer =~ /^[yY]/)
{
	$pat = <STDIN>;
	chomp($pat);
}
else{}

print "Would you like to compare the expression to a single string or to the Dictionary? (1-single|2-Dictionary)\n";
print "> ";
$answer = <STDIN>;
chomp($answer);

if($answer == 1)
{
	print "String to compare?: ";
	$str = <STDIN>;
	chomp($str);

	while($str)
	{
		if($str =~ $pat)
		{ print "Match\n";}
		else
		{ print "NO match\n";}
		print "String to compare?: ";
		$str = <STDIN>;
		chomp($str);
	}
}
elsif($answer == 2)
{
	open(DICT,$wordfile) || die "dictionary not found.\n";
	while($word=<DICT>)
	{
		chomp($word);
		if($word =~ /$pat/)
		{ print "$word\n";}
	}
	close(DICT);
}
else
{
	print "INVALID PLEASE REENTER CHOICE\n";
}	
