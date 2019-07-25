#!/bin/bash
#https://unix.stackexchange.com/questions/253816/restrict-size-of-buffer-cache-in-linux
echo 3 > /proc/sys/vm/drop_caches
