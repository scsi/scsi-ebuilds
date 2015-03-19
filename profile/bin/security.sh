#!/bin/bash
EXTIF=eth0
fire=/usr/local/virus/iptables
date=`date +%y%m%d`
echo $1|grep "^[0-9]*.*.*.*[0-9]$" > /dev/null 2>&1
if [ "$?" == "0" ]; then
        ip=$1
else
        ip=`/usr/bin/host $1|awk '{print $4}'`
fi
cat $fire/iptables.deny|grep $ip > /dev/null 2>&1
if [ ! "$?" == "0" ]; then
echo -n '/sbin/iptables -A INPUT -i $EXTIF -s ' >> $fire/iptables.deny
echo -n "$ip -j DROP" >> $fire/iptables.deny
echo "  #$2 attack $date" >> $fire/iptables.deny
$fire/iptables.rule
echo "Service $2 was attack from $1"| mail -s "Security notice $ip" root
echo "Warning !! connection not allowed. Your attempt has been logged."
echo "你不被允許使用此連線"
fi 
