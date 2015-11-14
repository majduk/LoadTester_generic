#!/usr/bin/env bash

GLOBAL_CONFIG="$1"

source "$GLOBAL_CONFIG"
threadcount="0"
is_running="0"

echo `date $LOGDATEFORMAT`" Monitor scenario"

if [ -f "$SCENARIO_LOCK_FILE" ]; then
  is_running=1;
else
  is_running=0;
fi

if [ $is_running = "1" ]; then 
  threadcount=`ls -la $THREAD_SYNC_LOCK* 2>/dev/null | wc -l`
  if [ $threadcount = "0" ];then
    if [ -f "$SCENARIO_LOCK_FILE" ]; then
      echo "Execution finished";
      rm -r "$SCENARIO_LOCK_FILE";
    fi
  fi
fi 

echo `date $LOGDATEFORMAT`" Monitor scenario ($threadcount threads) - done"

