#!/usr/bin/env bash

GLOBAL_CONFIG="$1"

source "$GLOBAL_CONFIG"

stat_print="file"

if [ "$2" != "" ]; then
  stat_print=$2;
fi

function write_stat()
{
  str="$1";
  if [ "$stat_print" = "file" ]; then 
    echo "$str" >> $SYSTEM_STATS;
    #echo "$str" > $SCENARIO_STATS_CURR;
  else
    echo "$str";
  fi 
}

#set -x

echo `date $LOGDATEFORMAT`" System statistics ($stat_print)"

if [ -f "$STAT_LOCK_FILE" ]; then
  is_running=1;
else
  is_running=0;
  #is_running=1;
fi

if [[ $is_running = "1" || "$stat_print" != "file" ]]; then 
    stat_time=`date +%Y/%m/%d_%H:%M:%S`;
    stat_timestamp=`$INSTALLDIR/bin/unix_timestamp.sh`;
    
    #dziala tylko na solarisie
    stat=`/usr/local/bin/top -d1 -n -I -u 0`;
    
    loadavg1=`echo "$stat" | grep 'load' | awk '{ FS = " " } ; { print $6 };' | awk '{ FS = "," } ; { print $1 };'`;
    loadavg5=`echo "$stat" | grep 'load' | awk '{ FS = " " } ; { print $7 };' | awk '{ FS = "," } ; { print $1 };'`;
    loadavg15=`echo "$stat" | grep 'load' | awk '{ FS = " " } ; { print $8 };' | awk '{ FS = "," } ; { print $1 };'`;
    
    processes=`echo "$stat" | grep 'processes' | awk '{ FS = " " } ; { print $1 };'`
    
    memory_free=`echo "$stat" | grep 'Memory' | awk '{ FS = " " } ; { print $4 };'`
    memory_total=`echo "$stat" | grep 'Memory' | awk '{ FS = " " } ; { print $2 };'`
    swap_use=`echo "$stat" | grep 'Memory' | awk '{ FS = " " } ; { print $6 };'`
    swap_free=`echo "$stat" | grep 'Memory' | awk '{ FS = " " } ; { print $10 };'`

    if [ "$stat_print" != "file" ]; then 
       echo "STAT_TIME STAT_TIMESTAMP LOADAVG1 LOADAVG5 LOADAVG15 PROCESSES MEMORY_FREE MEMORY_TOTAL SWAP_USE SWAP_FREE";
    fi 
    write_stat "$stat_time $stat_timestamp $loadavg1 $loadavg5 $loadavg15 $processes $memory_free $memory_total $swap_use $swap_free";
    
fi
echo `date $LOGDATEFORMAT`" System statistics - done"

