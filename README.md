# fix-hostname

Make sure that a Mac’s LocalHostName and ComputerName match

Purpose: OS X 10.10 has a problem where the 'LocalHostName' ends up with a '-2' at the end of the name.
To work around this, I set the 'ComputerName' to the same thing as what I want 'LocalHostName' to
be, and then use this script to make sure they are identical.

For more info on these names, see: <http://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html>

## Installation and Setup

1.	Install `fix-hostname.sh` to somewhere such as `/usr/local/scripts/`

2.	Install

If you want this script to be able to run unattended (i.e. via `launchd`, then you need to use
'sudo visudo' to add one of these lines to your sudoers file:

	%admin ALL=NOPASSWD: /usr/sbin/scutil

or

	%admin ALL=NOPASSWD: /usr/sbin/scutil --set LocalHostName

If you are the only user of your Mac, I recommend  first one.

You can check to see what your ComputerName and LocalHostName values are using:

	scutil --get ComputerName

and

	scutil --get LocalHostName

