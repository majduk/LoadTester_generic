#!/usr/bin/env bash

source "$1"

echo `date $LOGDATEFORMAT`" Application access lock aquire "
RC=$APPLOCKFAILED
if [ -f "$APPLOCKFILE" ];then
	echo "FAILED";
else
	touch "$APPLOCKFILE";
	if [ -f "$APPLOCKFILE" ];then
	 echo "AQUIRED";
	 RC=$APPLOCKAQUIRED;
	else
	 echo "FAILED";
	fi
fi
echo `date $LOGDATEFORMAT`" Application access lock aquire - done"
exit $RC