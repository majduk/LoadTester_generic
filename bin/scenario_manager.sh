#!/usr/bin/env bash

GLOBAL_CONFIG="$1"
source "$GLOBAL_CONFIG"
source "$SCENARIOMANAGERCONFIG"
command="$2";
scenario="$3"
exec="0"
found="0"

echo `date $LOGDATEFORMAT`" Manage scenario ($command, $scenario)"

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
      is_running=0;
      rm -r "$SCENARIO_LOCK_FILE";
    fi
  fi
fi 

if [[ "$is_running" = "1" && "$command" = "$START_COMMAND"  ]] || [[ "$is_running" = "0"  &&  "$command" = "$STOP_COMMAND" ]]; then
  echo "Execution aborted; command already run"
else
  exec="1"
fi 

for scenario_name in $SCENARIOS; do
    if [ "$scenario_name" = "$scenario" ]; then
      found="1";
    fi
done

if [ "$found" != "1" ]; then
  echo "Execution aborted; no such scenario"
fi

if [[ "$exec" = "1" && "$found" = "1" ]]; then
    case $command in
     "$START_COMMAND") echo "STARTING SCENARIO $scenario"
     echo "$command" > "$SCENARIO_LOCK_FILE"
     $INSTALLDIR/bin/scenario_runner.sh "$GLOBAL_CONFIG" $scenario &
     ;;
     "$STOP_COMMAND")  echo "STOPPING SCENARIO $scenario"
     rm -f "$SCENARIO_LOCK_FILE"
     ;;
     "$PAUSE_COMMAND") echo "PAUSING SCENARIO $scenario"
     echo "$command" > "$SCENARIO_LOCK_FILE"
     ;;
     "$RESUME_COMMAND") echo "RESUMING SCENARIO $scenario"
     echo "$START_COMMAND" > "$SCENARIO_LOCK_FILE"
     ;; 
     *) echo "Command unrecognized";;
    esac
fi

echo `date $LOGDATEFORMAT`" Manage scenario - done"

