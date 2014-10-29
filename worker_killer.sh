#!/bin/bash
function abs()
{
  # Check for numeric input
  if expr $1 + 0 2>/dev/null 1>&2 ; then
    if [ $1 -lt 0 ]; then
      echo `expr 0 - $1`
    else
      echo $1
    fi
    return 0
  else
    return 1
  fi
}
function date_compare()
{
  # 1970/01/01 00:00:00 からの経過秒に変換
  ARG1_SECOND=`date -d "$1" '+%s'`
  ARG2_SECOND=`date -d "$2" '+%s'`

  # 差を返却
  abs `expr $ARG2_SECOND - $ARG1_SECOND`
}

echo `date '+[%Y-%m-%d %H:%M:%S] START'`
MAX_LENGTH=1800 #60*60*1/2
PID=`ps -eo pid,cmd --sort=start_time | grep resque | grep Processing | head -n1 | awk '{print $1}'`
ETIME=`ps -p $PID -o etime --no-header`
echo `date '+[%Y-%m-%d %H:%M:%S] ETIME'" $ETIME"`
ret=`date_compare "00:00:00" "00:$ETIME"`
echo `date '+[%Y-%m-%d %H:%M:%S] ret'" $ret"`
if [ $ret -gt $MAX_LENGTH ]; then
  kill -9 $PID
  echo `date '+[%Y-%m-%d %H:%M:%S] killed'" $PID"`
else
  echo `date '+[%Y-%m-%d %H:%M:%S] OK'`
fi
echo `date '+[%Y-%m-%d %H:%M:%S] END'`
