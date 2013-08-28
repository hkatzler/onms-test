#!/bin/bash
ROUTER="10.3.96.11"
DIFFTIME="10"
IFINOCT="1.3.6.1.2.1.2.2.1.10"
INT="1"
COID="${IFINOCT}.${INT}"
VALUE1=$(snmpwalk -Os -c gpcisco -v 1 $ROUTER $COID | awk '{print $4}')
sleep $DIFFTIME
VALUE2=$(snmpwalk -Os -c gpcisco -v 1 $ROUTER $COID | awk '{print $4}')
KBITS_VALUE1=$(echo "$VALUE1 8" | awk '{sum=$1 * $2} {print sum}')
KBITS_VALUE2=$(echo "$VALUE2 8" | awk '{sum=$1 * $2} {print sum}')
DIFF=$(echo "$KBITS_VALUE2 $KBITS_VALUE1" | awk 'BEGIN {FS=" "} {sum=$1 - $2} {print sum}')
SPEED=$(echo "$DIFF $DIFFTIME 1000" | awk 'BEGIN {FS=" "} {sum=$1 / $2 / 1000} {print sum}' | awk 'BEGIN {FS="."} {print $1}')
#echo "$SPEED Kbit/s"

if [ "$SPEED" lt "100" ]
 then
  echo "Alarm"
 else
  echo "Speed OK $SPEED" | mailx -s "D2 Speedcheck Aktuell: $SPEED kBit/s" sven.sotta@gls-germany.com
 fi 
