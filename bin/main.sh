#!/usr/bin/env bash

DEFAULT_CONFIG_DIR="/home/ajdukm/apps/LoadTester/etc";

if [ "$1" = "" ];then
  CONFIGDIR=$DEFAULT_CONFIG_DIR
  CONFIGFILE=$CONFIGDIR/"config.sh"
else
  CONFIGFILE="$1"
fi
source "$CONFIGFILE";

exec 2>&1 >> "$LOGDIR/$LOGFILE"

if [ -f "$LOGROTATE" ]; then
  /usr/sbin/logrotate --state $LOGROTATESTATUS $LOGROTATECONFIG
fi

echo `date $LOGDATEFORMAT`" +++++++++++++++++++++++ RUN START +++++++++++++++++++++++"

$INSTALLDIR/bin/app_lock_aquire.sh $CONFIGFILE >> $LOGDIR/$LOGFILE 2>&1
lck=$?;
if [ "$lck" = "$APPLOCKAQUIRED" ];then 

  for tool in $MAIN_TOOLCHAIN;do
    $INSTALLDIR/bin/$tool $CONFIGFILE >> $LOGDIR/$LOGFILE 2>&1
  done
  
  $INSTALLDIR/bin/app_lock_release.sh $CONFIGFILE >> $LOGDIR/$LOGFILE 2>&1
fi

echo `date $LOGDATEFORMAT`" +++++++++++++++++++++++ RUN   END +++++++++++++++++++++++" 