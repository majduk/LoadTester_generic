#!/usr/bin/env bash

DEFAULT_CONFIG_DIR="/home/ajdukm/apps/LoadTester/etc";

CRON_COUNT=1;
CRON_SLEEP=0;

if [ "$1" = "" ];then
  CONFIGDIR=$DEFAULT_CONFIG_DIR
  CONFIGFILE=$CONFIGDIR/"config.sh"
else
  CONFIGFILE="$1"
fi
source "$CONFIGFILE";

for ((i=0; i<$CRON_COUNT; i++  )); do
  $INSTALLDIR/bin/main.sh $CONFIGFILE &
  sleep $CRON_SLEEP;
done 