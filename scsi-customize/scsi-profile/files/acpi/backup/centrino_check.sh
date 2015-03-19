#!/bin/sh

ret=`lsmod | awk '{print $1}' | grep -c ndiswrapper`
if [ $ret = "1" ] ; then
   /etc/acpi/centrino_wlan.sh stop
else
   /etc/acpi/centrino_wlan.sh start
fi
