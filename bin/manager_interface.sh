#!/usr/bin/env bash

DEFAULT_CONFIG_DIR="/home/ajdukm/apps/LoadTester/etc";
if [ "$1" = "help" ]; then
  echo "Usage <script> <config file> <command|local> <param> [local param]"
  echo "if command is \"local\" then \"param\" is local command and \"local param\" is command param"
  exit;
fi

if [ "$1" = "" ];then
  CONFIGDIR=$DEFAULT_CONFIG_DIR
  CONFIGFILE=$CONFIGDIR/"config.sh"
else
  CONFIGFILE="$1"
fi
source "$CONFIGFILE";

id=`date +%Y%m%d%H%M%S`
command=$2
param=$3

for c in "$START_COMMAND" "$STOP_COMMAND" "$PAUSE_COMMAND" "$RESUME_COMMAND"; do 
  if [ "$c" = "$command" ]; then
    echo "$id $command $param" > $COMMONCMDFILE
    echo "Stored command"
    cat "$COMMONCMDFILE"
  fi 
done

if [ "$command" = "$STATUS_COMMAND" ];then
   $INSTALLDIR/bin/scenario_monitor.sh $CONFIGFILE
   if [ "$param" = "" ];then param="summary";fi  
   $INSTALLDIR/bin/scenario_stat.sh $CONFIGFILE $param print
   $INSTALLDIR/bin/system_stat.sh $CONFIGFILE print
fi
if [ "$command" = "local" ]; then
  $INSTALLDIR/bin/scenario_manager.sh $CONFIGFILE $param $4
fi
if [ "$command" = "stat" ]; then
  if [ "$param" = "start" ]; then
    if [ -f "$STAT_LOCK_FILE" ];then
      echo "Scenario already running. Statistics are collected"
    else
      echo "Statistics are now collected"
      echo "$command" > "$STAT_LOCK_FILE"
    fi
  fi
  if [ "$param" = "stop" ]; then
    if [ -f "$STAT_LOCK_FILE" ];then
      read cmd < "$STAT_LOCK_FILE"
      if [ "$cmd" = "stat" ];then
        rm -f "$STAT_LOCK_FILE"
      fi
    else
      echo "Statistics are not collected"
    fi
  fi  
fi