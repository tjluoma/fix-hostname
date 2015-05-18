#!/bin/zsh -f
############################################################################################################
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2015-05-16
#
# Purpose: OS X 10.10 has a problem where the 'LocalHostName' ends up with a '-2' at the end of the name.
#			To work around this, I set the 'ComputerName' to the same thing as what I want LocalHostName to
#			be, and then use this script to make sure they are identical.
#
# For more info on these names, see:
# http://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html
#
############################################################################################################
#
# You can check to see what your ComputerName and LocalHostName values are using:
#
#	scutil --get ComputerName
#
# and
#
# 	scutil --get LocalHostName
#
############################################################################################################
#
# If you want this script to be able to run unattended (i.e. via `launchd`),
#
#
############################################################################################################

NAME="$0:t:r"

LOCAL_HOST_NAME=`/usr/sbin/scutil --get LocalHostName`

COMPUTER_NAME=`/usr/sbin/scutil --get ComputerName`

	# If the values are identical, quit (nothing to fix)
[[ "$COMPUTER_NAME" == "$LOCAL_HOST_NAME" ]] && exit 0

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#		If we get to this point, the hostnames do not match, but should
#
zmodload zsh/datetime

function msg {

	function timestamp { strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS" }

	echo "$NAME [`timestamp`]: $@" | tee -a "$HOME/Library/Logs/$NAME.log"

	if (( $+commands[growlnotify] ))
	then
			# if Growl.app is running and `growlnotify` is installed…
		pgrep -qx Growl && \
		growlnotify \
			--appIcon "Network Utility" \
			--identifier "$NAME" \
			--message "$@" \
			--title "$NAME"
	fi

	if (( $+commands[po.sh] ))
	then
		po.sh "$@"
	fi
}

	# Make sure that 'ComputerName' is actually set to something
if [[ "$COMPUTER_NAME" == "" ]]
then
	msg "\$COMPUTER_NAME is empty. Use 'sudo scutil --set ComputerName XYZ' to set it to XYZ"
	exit 0
fi

	# Try to set the LocalHostName to whatever the ComputerName is:

if [[ "$EUID" == "0" ]]
then
	/usr/sbin/scutil --set LocalHostName "$COMPUTER_NAME"
else
	sudo /usr/sbin/scutil --set LocalHostName "$COMPUTER_NAME"
fi

SET_LOCAL_HOST_NAME="$?"

	# Get the new value of LocalHostName (to see if it was successful)
LOCAL_HOST_NAME=`/usr/sbin/scutil --get LocalHostName`

if [[ "$COMPUTER_NAME" == "$LOCAL_HOST_NAME" ]]
then
		# It was successful
	msg "Successfully reset LocalHostName to $LOCAL_HOST_NAME"
else
		# It was not successful
	msg "Failed to reset LocalHostName ($LOCAL_HOST_NAME) to ComputerName ($COMPUTER_NAME). scutil exit code: $SET_LOCAL_HOST_NAME (should be zero)"
fi

exit 0
#
#EOF