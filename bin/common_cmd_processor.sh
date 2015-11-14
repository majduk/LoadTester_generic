#!/usr/bin/env bash

GLOBAL_CONFIG="$1"
source "$GLOBAL_CONFIG"

echo `date $LOGDATEFORMAT`" Processing Commands"
#wczytywanie komendy
if [ -f "$COMMONCMDFILE" ];then
  read id command param < "$COMMONCMDFILE"
  read prv_id prv_command prv_param < "$PRIVATECMDFILE"
  if [ "$prv_id" != "$id" ]; then
    echo "Received command: $id $command $param"
    echo "$id $command $param" > $PRIVATECMDFILE 
    $INSTALLDIR/bin/scenario_manager.sh $GLOBAL_CONFIG $command $param
  fi
fi

echo `date $LOGDATEFORMAT`" Processing Commands - done"

