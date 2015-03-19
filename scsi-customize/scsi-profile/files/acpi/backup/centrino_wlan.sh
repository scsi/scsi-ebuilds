#!/bin/sh

case "$1" in
    start)
       cd /home/am/bin/wlan
       insmod ndiswrapper.o
       ./loaddriver 8086 1043 w70n51.inf w70n51.sys
       iwconfig eth1 power off
       iwconfig eth1 mode Managed
       iwconfig eth1 key open XXXXXXXXXXXXXXXXXX
       iwconfig eth1 essid XXXXXXXXXX
       ifconfig eth1 192.168.1.2
       route add default gw 192.168.1.1
       echo 1 > /proc/acpi/asus/wled
       ;;
    stop)
       route del default
       ifconfig eth1 down
       rmmod ndiswrapper
       echo 0 > /proc/acpi/asus/wled
       ;;
esac 
