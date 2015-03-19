#!/bin/sh

ret=`lsmod | awk '{print $1}' | grep -c ipw2200`

case "$ret" in
    0)
       #insmod ipw2200
       modprobe ipw2200
       #modprobe ieee80211
       #modprobe ieee80211_crypt
       #modprobe ieee80211_crypt_wep
       iwconfig eth1 power off
       iwconfig eth1 mode Managed
       #iwconfig eth1 key open XXXXXXXXXXXXXXXXXX
       #iwconfig eth1 essid XXXXXXXXXX
       iwconfig eth1 essid firefox key 09198868012707446727368088 nick scsinb
       /etc/init.d/net.eth1 start
       echo 1 > /proc/acpi/asus/wled
       ;;
    1)
       /etc/init.d/net.eth1 stop
       rmmod ipw2200
       echo 0 > /proc/acpi/asus/wled
       ;;
esac

