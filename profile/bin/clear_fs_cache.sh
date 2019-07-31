#!/bin/bash
#https://unix.stackexchange.com/questions/253816/restrict-size-of-buffer-cache-in-linux
# 1: 
#
# sudo sysctl vm.drop_caches=3
echo 3 > /proc/sys/vm/drop_caches

#vm.min_free_kbytes looks like it could help. Eg. executing
#echo 5248000 > /proc/sys/vm/min_free_kbytes
