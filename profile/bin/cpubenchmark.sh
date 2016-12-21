#!/bin/bash
#http://www.linuxidc.com/Linux/2009-06/20495.htm
#邏輯CPU個數
#cat /proc/cpuinfo | grep "processor" | wc -l

#"physical CPU number:"
#物理CPU個數：
#cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l

#"core number in a physical CPU:"
#每個物理CPU中Core的個數：
#cat /proc/cpuinfo | grep "cpu cores" | uniq | awk -F: '{print $2}'

#查看每個physical cpu上core id的數量,即為每個物理CPU上的core的個數
#cat /proc/cpuinfo | grep "core id"

#是否為超執行緒？
#如果有兩個邏輯CPU core具有相同的”core id”，那麼超執行緒是打開的。
# 當然也可知直接查詢 /proc/cpuinfo 中的 "ht"這個flag
#cat /proc/cpuinfo | grep flags | grep ht

#每個物理CPU中邏輯CPU(可能是core, threads或both)的個數：
#cat /proc/cpuinfo | grep "siblings"

C=10000000000
stime=`date +%s%3N`
echo 'scale=5000; 4*a(1)' | bc -l -q >/dev/null
etime=`date +%s%3N`
((goal=C/(etime-stime)))
nc=`nproc`
printf "echo CPU: %'d = %'d * %d\n" $((goal*nc)) $goal $nc
