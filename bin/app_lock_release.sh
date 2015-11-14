#!/usr/bin/env bash

source "$1"

echo `date $LOGDATEFORMAT`" Application access lock release "

if [ -f "$APPLOCKFILE" ];then
	rm -f "$APPLOCKFILE"
fi

echo `date $LOGDATEFORMAT`" Application access lock release - done"
