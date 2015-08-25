#!/bin/bash
. ./commfunc.sh

#singlexec(){ _buexec "$1" "$2" "$3" "single"; }
#multiexec(){ _buexec "$1" "$2" "$3" "multi" & cpid=$!; [ -n "$4" ] && eval $4=\"\$$4 $cpid\"; }
#waitchild(){ local jl;[ -n "$1" ]&&eval jl=\"\$$1\"||jl=`jobs -p`;for job in $jl; do wait $job; done; }
#maxchild(){ while [ `local cols=(jobs -p);echo ${#cols[@]}` -gt $1 ];do usleep 500; done; }
#_killchild(){ kill `jobs -p`; }


multiexec "sleep" "sleep 2" 2 SLEEP
multiexec "sleep" "sleep 2" 2 SLEEP
multiexec "sleep1" "sleep 5" 2 SLEEP1
multiexec "sleep1" "sleep 5" 2 SLEEP1
echo $SLEEP
waitchild SLEEP

echo finish SLEEP
waitchild
echo all finish

readprop ~/aa.p aaa
readcfg ~/bb.p second aaa
