#!/bin/bash

lsmod|grep -q configs||modprobe configs
cat /proc/config.gz|gunzip
