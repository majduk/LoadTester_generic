#!/usr/bin/env bash

GLOBAL_CONFIG="$1"

source "$GLOBAL_CONFIG"
source "$SCENARIOMANAGERCONFIG"
scenario="$2"

#set -x

if [ "$SCENARIO_LOGFILE" != "" ]; then
  exec 2>&1 >> $SCENARIO_LOGFILE
fi

function run_scenario_thread ()
{
  local thread_id=$1;
  local speed=$2;
  local count=$3
  local accel=$4;
  
  counter=0;
  sleep=$speed;
  
  echo `date`" "`hostname`" Starting thread $thread_id"

  lockname=$THREAD_SYNC_LOCK."$thread_id"
  if [ -f $lockname ]; then
     echo `date`" "`hostname`" PANIC! thread $thread_id already exist"
     exit $EXECUTION_ERROR;
  fi
  touch "$lockname";

  #random sleep
  rand=$RANDOM
  let "rand %= $RANDOM_SLEEP"
  echo `date`" "`hostname`" Going into initial sleep for $rand seconds";
  sleep $rand;

  start_time=`$INSTALLDIR/bin/unix_timestamp.sh`;
  while [ true ]; do
    
  cmd="$STOP_COMMAND";
  if [ -f "$SCENARIO_LOCK_FILE" ]; then
    read cmd < "$SCENARIO_LOCK_FILE"
  fi  
  
  case $cmd in 
  "$PAUSE_COMMAND")
    sleep $PAUSE_SLEEP;
    continue;
  ;;
  "$START_COMMAND")
    if [ $counter = $count ];then 
      break;
    else
      counter=`expr "$counter" + "1"` ; 
    fi
    
    echo message;
    
    now_time=`$INSTALLDIR/bin/unix_timestamp.sh` 
    
    echo "$start_time $now_time $counter" > $THREAD_STAT."$thread_id";
    
    if [ $sleep -lt "0" ]; then
      sleep=0;
    fi  
    sleep $sleep;
    sleep=`expr "$sleep" - "$accel"` ;
    
  ;;
  *) 
    break;
  ;;  
  esac  
  done

  rm -f $lockname;
  echo `date`" "`hostname`" Finishing thread $thread_id"
}

echo `date`" "`hostname`" Starting scenario ($scenario)" 

    profile=$scenario
    for param in $SCENARIO_PARAMS; do
      eval param_"$profile"_"$param"=\$"$profile""_""$param";
      eval val=\$param_"$profile"_"$param";
      if [ "$val" = "" ]; then
        eval param_"$profile"_"$param"=\$"DEFAULT_$param";
      fi
      eval $param=\$param_"$profile"_"$param";
      eval dbg=\$"$param";
      echo `date`" "`hostname`" Setting $profile $param=$dbg";  
    done

for ((i=0; i<$THREADS; i++ )); do
  run_scenario_thread $i $SPEED $COUNT $ACCEL &
done        


echo `date`" "`hostname`" Starting scenario - done"

