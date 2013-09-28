#! /usr/bin/perl -w

print "Pattern? ";
$pat = <STDIN>;
chomp($pat);

print "\nString? ";
$str = <STDIN>;
chomp($str);
while ($str)
{
	if($str =~ $pat)
	{
		print "match\n";
	}
	else
	{
		print "no match\n";
	}
	print "\nString? ";
	$str = <STDIN>;
	chomp($str);
}
