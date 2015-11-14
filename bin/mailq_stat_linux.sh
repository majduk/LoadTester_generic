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
    echo "$str" >> $MAILQ_STATS;
  else
    echo "$str";
  fi 
}

#set -x

echo `date $LOGDATEFORMAT`" Mailq statistics ($stat_print)"

if [ -f "$STAT_LOCK_FILE" ]; then
  is_running=1;
else
  is_running=0;
  #is_running=1;
fi

if [[ $is_running = "1" || "$stat_print" != "file" ]]; then 
    stat_time=`date +%Y/%m/%d_%H:%M:%S`;
    stat_timestamp=`$INSTALLDIR/bin/linux_timestamp.sh`;
    
    stat=`mailq | tail -n1`
    requests=`echo "$stat" | grep 'requests' | awk '{ FS = " " } ; { print $3 };'`;

    if [ "$stat_print" != "file" ]; then 
       echo "STAT_TIME STAT_TIMESTAMP QUEUE";
    fi 
    write_stat "$stat_time $stat_timestamp $requests";
    
fi
echo `date $LOGDATEFORMAT`" Mailq statistics - done"

