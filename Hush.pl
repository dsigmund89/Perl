#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd;


my ($temp, $CWD, $LWD, $command, $pid, $home_dir, $prompt, $profileFile, $historyFile, $hash, $alias, $set, $line, $curLine, $curKey, $curVal, @line, @aliases, @sets, %hash, %alias, %set);
 
	$home_dir = $ENV{"HOME"};
	$prompt = $ENV{"PROMPT"};
	$CWD = getcwd();
	$LWD = getcwd();
	$ENV{"CWD"} = $CWD;
	$ENV{"LWD"} = $LWD;

	$profileFile = $home_dir . "/.hush_profile.txt";
	$historyFile = $home_dir . "/.hush_history.txt";
do
{
	if(-s $profileFile && -r $profileFile)
	{
		open(PROFILE, "$profileFile");
		
		while($curLine = <PROFILE>)
		{
			chomp $curLine;
			
			@line = split(" ", $curLine);
			
			$curKey = $line[1];
			
			if($line[0] eq "alias")
			{
				push(@aliases, $curKey);
				
				@line = split("= ", $curLine);
				
				$hash{"$curKey"} = "$line[1]";
				$alias{"$curKey"} = "$line[1]";
			}
			if($line[0] eq "set")
			{
				push(@sets, $curKey);
				
				@line = split("= ", $curLine);
				
				$hash{"$curKey"} = "$line[1]";
				$set{"$curKey"} = "$line[1]";
				
				if ($curKey eq "PROMPT")
				{
					print "$line[1] ";
				}
			}
		}
	}
	else
	{
		print "[hush:" . $$ . "]\$ ";
	}	
	$command = <STDIN>;
	chomp($command);
 
	unless ( lc($command) eq "exit" 
			|| lc($command) eq "cd" 
			|| lc($command) eq "alias"
			|| lc($command) eq "set"
			|| lc($command) eq "last"
			|| lc($command) eq "history")
	{
	
		$pid = fork();
		if ($pid < 0)
		{
			print "Unable to use fork() function.\n";
			exit 0;
		}
		elsif ($pid > 0)
		{ # parent process will execute this branch of the if statement:
			wait();
		}
		else
		{ # child process will execute this branch:
			
			while( ($curKey, $curVal) = each(%hash))
			{
				if( $command eq $curKey)
				{
					$command = $curVal;
				}
			}
			exec($command);
			exit 0;     # Make absolutely SURE that child doesn’t get past this point!	
		}
	}
	if( lc($command) eq "cd" )
	{
		chdir();
		$temp = $CWD;
		$CWD = getcwd();
		$LWD = $temp;
	}
	if( lc($command) eq "alias")
	{
		while( ($curKey, $curVal) = each(%alias))
		{
			print "Alias: $curKey = $curVal\n";
		}
	}
	if( lc($command) eq "set")
	{
		while( ($curKey, $curVal) = each(%set))
		{
			print "Set: $curKey = $curVal\n";
		}
	}
	if( lc($command) eq "last")
	{
		chdir($LWD);
		$temp = $CWD;
		$CWD = getcwd();
		$LWD = $temp;
	}
	if( lc($command) eq "history")
	{
		open(HISTORY, ">>$home_dir" . "/.hush_history.txt");
		print HISTORY "$command\n";
		open(HISTORY, "$home_dir" . "/.hush_history.txt");
		while($command = <HISTORY>)
		{
			chomp($command);
			print "$command\n";
		}
	}
	
	if( lc($command) eq "")
	{}
	else
	{
		open(HISTORY, ">>$home_dir" . "/.hush_history.txt");
		print HISTORY "$command\n";
	}
	
} 
while ( lc($command) ne "exit" );
	close(PROFILE);
	close(HISTORY);