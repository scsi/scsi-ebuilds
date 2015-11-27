#!/bin/bash
. ./commfunc.sh

#singlexec(){ _buexec "$1" "$2" "$3" "single"; }
#multiexec(){ _buexec "$1" "$2" "$3" "multi" & cpid=$!; [ -n "$4" ] && eval $4=\"\$$4 $cpid\"; }
#waitchild(){ local jl;[ -n "$1" ]&&eval jl=\"\$$1\"||jl=`jobs -p`;for job in $jl; do wait $job; done; }
#maxchild(){ while [ `local cols=(jobs -p);echo ${#cols[@]}` -gt $1 ];do usleep 500; done; }
#_killchild(){ kill `jobs -p`; }

printtitle SLEEP 
multiexec "sleep" "sleep 2" output=always group=SLEEP
multiexec "sleep" "sleep 2" output=onsuccess group=SLEEP
multiexec "sleep1" "sleep 3" output=onfail group=SLEEP1
multiexec "sleep1" "sleep 5"  group=SLEEP1
multiexec "sleep1" "sleep 4;return 1"  group=SLEEP1
echo $SLEEP
waitchild SLEEP

echo finish SLEEP
waitchild
echo all finish
log "abc"
readprop ~/aa.p aaa
readcfg ~/bb.p second aaa

list_result
echo success
list_result success
echo fail
list_result fail
clear_result
