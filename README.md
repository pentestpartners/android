Android scripts

These are some generic scripts to do some hackery with Android, they may be helpful in some situations where access to a device is requested, or data needs to be interpreted from one.

The scripts here are:

brute-lock.pl
-------------
A perl script which will perform an automatic brute force of a 4 digit PIN on a device which has ADB enabled. It's similar to the rubber ducky attack, but it gets feedback.

Note, on Kit Kat your device will need to be authorised by ADB first. It looks good for a screenshot :-)

brute-lock-lollipop.pl
----------------------
An updated version of the above script which will attempt to brute force the lock code on a lollipop device. There have been some changes due to the pull up to unlock and the order of the layout. Like Kit Kat this will need to be run on a machine that has been authorised in advanced.

Strangely enough pressing menu will force it straight to the lockpad, but will overlay it over the keyguard notification screen.