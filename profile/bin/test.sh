#!/bin/bash
. ./commfunc.sh

#singlexec(){ _buexec "$1" "$2" "$3" "single"; }
#multiexec(){ _buexec "$1" "$2" "$3" "multi" & cpid=$!; [ -n "$4" ] && eval $4=\"\$$4 $cpid\"; }
#waitchild(){ local jl;[ -n "$1" ]&&eval jl=\"\$$1\"||jl=`jobs -p`;for job in $jl; do wait $job; done; }
#maxchild(){ while [ `local cols=(jobs -p);echo ${#cols[@]}` -gt $1 ];do usleep 500; done; }
#_killchild(){ kill `jobs -p`; }

testap1(){
  RETURN_TITLE="test title"
  RETURN_MESSAGE="test message"
  echo this is testap1
}

testap2(){
  RETURN_TITLE="test title"
  echo this is testap2
}

testap3(){
  RETURN_TITLE="test title"
  RETURN_MESSAGE="test message"
  echo this is testap3
  return 1
}

singlexec "test1" "testap1" output=format
singlexec "test1 always" "testap1" output=format-always
singlexec "test1 onsuccess" "testap1" output=format-onsuccess
singlexec "test1 onfail" "testap1" output=format-onfail
singlexec "test2" "testap2" output=format
singlexec "test3" "testap3" output=format
singlexec "test3 always" "testap3" output=format-always
singlexec "test3 onsuccess" "testap3" output=format-onsuccess
singlexec "test3 onfail" "testap3" output=format-onfail

printtitle SLEEP 
multiexec "sleep 2" "sleep 2" output=always group=SLEEP
multiexec "sleep 2" "sleep 2" output=onsuccess group=SLEEP
multiexec "sleep 3" "sleep 3" output=onfail group=SLEEP1
multiexec "sleep 5" "sleep 5"  group=SLEEP1
multiexec "sleep 4" "sleep 4;return 1"  group=SLEEP1
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
usedsec
usedmsec
