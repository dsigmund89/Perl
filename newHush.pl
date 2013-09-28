#!/usr/bin/perl -w
use strict;
use Cwd;

my ($a,$b ,$i , %commandList, $temp, $inline, $command, 
@restofline, $pid, $prompt, $CWD, $LWD, $home_dir, 
$profiletxt, $historytxt, @settings,$curKey,$curVal, %alias, %set);

        $home_dir = $ENV{"HOME"};                        
	$prompt = $ENV{"PROMPT"};
	$CWD = getcwd();
	$LWD = getcwd();
	
	$historytxt = $home_dir . "/.hush_history.txt";
	$profiletxt = $home_dir . "/.hush_profile.txt";

	open(HISTORYa, ">>$historytxt");
do
{
	if(-e $profiletxt && -r $profiletxt)
	{
		open(PROFILE, "$profiletxt")|| die "someting happend";
		while($inline = <PROFILE>)
		{
			chomp($inline);
			@settings = split(" ",$inline);
			$curKey = $settings[1];
			if($settings[0] eq "alias")
			{
				@settings = split("= ",$inline);
				$alias{"$curKey"} = "$settings[1]";
				$commandList{"$curKey"} = "$settings[1]";
			}
			elsif($settings[0] eq "set")
			{
				@settings = split("= ",$inline);
				$set{"$curKey"} = "$settings[1]";
				$commandList{"$curKey"} = "$settings[1]";
				if($curKey eq "PROMPT")
				{ print "$settings[1] "; }
			}
		}
	}
	else { print "[hush:$$]\$ "; }

	$inline = <STDIN>;
	chomp($inline);
	($command, @restofline) = split(" ",$inline);
	print HISTORYa "$command\n";
	
	unless ( lc($command) eq "exit"
		|| lc($command) eq "cd"
		|| lc($command) eq "alias"
		|| lc($command) eq "set"
		|| lc($command) eq "last"
		|| lc($command) eq "history")
	{
		while(($curKey, $curVal) = each(%commandList))
		{
			if($command eq $curKey)
			{ $command = $curVal; }
		}

		$pid = fork();
		if ($pid < 0)
		{
			print "Unable to use fork() function\n.";
			exit 0;
		}
		elsif ($pid > 0)
		{ 
			# parent process will execute this branch of the if statement:
			wait();
		}
		else
		{ 
			# child process will execute this branch:
			exec($command,@restofline);
			exit 0; # Make absolutely SURE that child doesn.t get past this point!
		}
	}
	if(lc($command) eq "cd")
	{
		$a = @restofline;
		($b, @restofline) = @restofline;
		if($a == 0)
		{
			chdir();
		}
		else
		{ chdir("$b"); }
			$LWD = $CWD;
			$CWD = getcwd();

	}
	if(lc($command) eq "alias")
	{
		while(($curKey, $curVal) = each(%alias))
		{ print "Alias: $curKey = $curVal\n"; }
	}
	if(lc($command) eq "set")
	{
		while(($curKey, $curVal) = each(%set))
		{ print "Set: $curKey = $curVal\n"; }
	}
	if(lc($command) eq "last")
	{
		chdir("$LWD");
		$LWD = $CWD;
		$CWD = getcwd();		
	}
	if(lc($command) eq "history")
	{
		close(HISTORYa);
		open(HISTORYr, "$historytxt");
		while($command = <HISTORYr>)
		{ 
			chomp($command);

			print ("$i\. $command\n");
			$i++;
		}
		close(HISTORYr);
		open(HISTORYa, ">>$historytxt");
	}
} while ( lc($command) ne "exit" );
close(HISTORYa);
