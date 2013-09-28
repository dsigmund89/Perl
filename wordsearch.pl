#! /usr/bin/perl -w
 
$wordfile = $ARGV[0] || "/usr/share/dict/words";
open(DICT,$wordfile) || die "dictionary not found.";
 
print "Regular Expression? ";
$regexpr = <STDIN>;
chomp($regexpr);
 
while ($word=<DICT>)
{
   chomp($word);
   if ($word =~ /$regexpr/) {print "$word\n";}
}
close(DICT);