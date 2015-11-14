#!/usr/bin/env bash
/usr/bin/truss /usr/bin/date 2>&1 |  nawk -F= '/^time\(\)/ {gsub(/ /,"",$2);print $2}'
exit $?
