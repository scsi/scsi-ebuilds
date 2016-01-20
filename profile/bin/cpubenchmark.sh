#!/bin/bash
#http://www.linuxidc.com/Linux/2009-06/20495.htm
C=10000000000
stime=`date +%s%3N`
echo 'scale=5000; 4*a(1)' | bc -l -q >/dev/null
etime=`date +%s%3N`
((goal=C/(etime-stime)))
nc=`nproc`
echo CPU: $((goal*nc)) = $goal \* $nc
