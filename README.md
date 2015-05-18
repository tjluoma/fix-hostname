# fix-hostname

OS X version 10.10 has a problem where the 'LocalHostName' ends up with a '-2' at the end of the name.

To work around this, I set the 'ComputerName' to the same thing as what I want 'LocalHostName' to
be, and then use this script to make sure they are identical.

For more info on these names, see: <http://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html>

## Installation and Setup (Option 1)

1.	Install `fix-hostname.sh` to somewhere such as `/usr/local/scripts/`

2.	Make sure `fix-hostname.sh` is excutable: `chmod 755 /usr/local/scripts/fix-hostname.sh`

3.	Install `com.tjluoma.fix-hostname.plist` to `$HOME/Library/LaunchAgents/`

4.	Tell `launchd` to load the new plist: `launchctl load $HOME/Library/LaunchAgents/com.tjluoma.fix-hostname.plist`

5. If you want this script to be able to run unattended (i.e. via `launchd`, then you need to use
'sudo visudo' to add one of these lines to your sudoers file:

	%admin ALL=NOPASSWD: /usr/sbin/scutil

or

	%admin ALL=NOPASSWD: /usr/sbin/scutil --set LocalHostName

If you are the only user of your Mac, I recommend  first one.

## Installation and Setup (Option 2)

1.	Install `fix-hostname.sh` to somewhere such as `/usr/local/scripts/`

2.	Make sure `fix-hostname.sh` is excutable: `chmod 755 /usr/local/scripts/fix-hostname.sh`

3.	Install `com.tjluoma.fix-hostname.plist` to `/Library/LaunchDaemons/`

4. 	Make the plist owned by `root:wheel` using this command: `sudo chown root:wheel /Library/LaunchDaemonscom.tjluoma.fix-hostname.plist`

5.	Tell `launchd` to load the new plist: `launchctl load /Library/LaunchDaemons/com.tjluoma.fix-hostname.plist`

## “Should I use Option 1 or Option 2?”

It’s a matter of personal preference.

Option 1 might be preferable if you are the only admin user of a Mac and may want to use `sudo scutil` command elsewhere without entering your password. The downside is that you have to edit the `sudoers` file (which should be OK if you use `sudo visudo`).

Option 2 means that the script will run regardless of which user is logged in, or even if no users are logged in. The downside is that in this case the entire script is run as root, rather than just one line. If you use that option, make sure that no one else can edit the `fix-hostname.sh` script, or they will be able to run commands as `root`.

Option 2 is probably the better choice because it runs even if no users are logged in, as long as the script is secure.

## Check Values

You can check to see what your ComputerName and LocalHostName values are using:

	scutil --get ComputerName

and

	scutil --get LocalHostName

## Removal / Uninstallation

1. 	Remove the file script: `rm /usr/local/scripts/fix-hostname.sh`

2. 	Unload the plist from `launchd`: `launchctl unload $HOME/Library/LaunchAgents/com.tjluoma.fix-hostname.plist` (or `launchctl unload /Library/LaunchDaemons/com.tjluoma.fix-hostname.plist` if you installed it there)

3.	Remove the plist: `rm $HOME/Library/LaunchAgents/com.tjluoma.fix-hostname.plist` (or `launchctl unload /Library/LaunchDaemons/com.tjluoma.fix-hostname.plist` if you installed it there)

## Optional

If `fix-hostname.sh` finds [po.sh](https://github.com/tjluoma/po.sh), it will use it to alert you via push notification when a change is made.

## Log

If any changes are attempted, `fix-hostname.sh` will log the result to `~/Library/Logs/fix-hostname.log`.

## Modifying

1) If you install the plist, the script will run every 5 minutes (300 seconds) plus when you log in.

To change that, edit the `300` listed below the `StartInterval`:

	<key>StartInterval</key>
	<integer>300</integer>

2) If you install the script somewhere _other_ than `/usr/local/scripts/fix-hostname.sh` edit the .plist `Program` as shown here:

	<key>Program</key>
	<string>/usr/local/scripts/fix-hostname.sh</string>

3) If you make any changes to the `plist` _after_ it is loaded, you must tell `launchd` to reload it, using these two lines:

	launchctl unload $HOME/Library/LaunchAgents/com.tjluoma.fix-hostname.plist

	launchctl load $HOME/Library/LaunchAgents/com.tjluoma.fix-hostname.plist

	(Change `$HOME/Library/LaunchAgents` to `/Library/LaunchDaemons/` if you installed it there)

