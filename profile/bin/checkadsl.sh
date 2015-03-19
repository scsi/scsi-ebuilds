#!/bin/sh
NETSERVICE=/etc/init.d/net.eth1
. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"
set -x
DNSIP=139.175.252.16


if [ "$(${NETSERVICE} status |awk '{print $3}')" = "started" ]
then
	if ping -c 1 $DNSIP -W 10 >/dev/null 2>&1
	then
		ping -c 1 www.seed.net.tw -W 10 >/dev/null 2>&1 || echo "nameserver $DNSIP" >/etc/resolv.conf
	fi
	
	pppip=`ifconfig|grep -A1 ppp0|grep inet|tr -s ' '|cut -d' ' -f3|cut -d ':' -f2`
	domainip=`ping -c 1 scsi.dyndns.org 2>/dev/null|grep PING|cut -d"(" -f2|cut -d")" -f1`
	[ "$pppip" = "$domainip" -a -n "$pppip" ] && exit 0
	if ping -c 1 www.seed.net.tw -W 10 >/dev/null 2>&1
	then
		echo "update dns."|tee -a /dev/stderr|logger -t checkadsl
		/root/bin/updatedns.sh
		sleep 30
	fi
	
	for tm in `seq 1 5`
	do
		pppip=`ifconfig|grep -A1 ppp0|grep inet|tr -s ' '|cut -d' ' -f3|cut -d ':' -f2`
		domainip=`ping -c 1 scsi.dyndns.org 2>/dev/null|grep PING|cut -d"(" -f2|cut -d")" -f1`
		[ "$pppip" = "$domainip" -a -n "$pppip" ] && break

		echo "restart adsl.	[${tm}]"|tee -a /dev/stderr|logger -t checkadsl
		${NETSERVICE} stop
		ps -aef|grep -v $(basename $0)|grep -e ppp -e adsl|awk '{print $2}'|xargs kill -9
		sleep 10
		${NETSERVICE} zap
		sleep 10
		${NETSERVICE} start
		sleep 30
	done
fi
