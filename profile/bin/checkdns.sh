#!/bin/sh
#set -x

. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"

ETH=ppp0
REALETH=eth0
DNSNAME="scsi.dyndns.org"
RETRY=3
TIMEOUT=30
TIMEWAIT=60
DNSIP=139.175.252.16

echo
date

ifconfig ${ETH} >/dev/null 2>&1

if [ ! $? = 0 ]
then
	/etc/init.d/net.${REALETH} restart
else
	printf "check vpn - "
	ping -c 1 scsioffice -W 5 >/dev/null 2>&1
	if [ $? = 0 ]
	then
		echo "success! ^^y"
	else
		echo "fail! T_T"

		for aa in `ifconfig |grep ppp|grep -v ppp0|awk '{print $1}'`
		do
			echo "	shutdown vpn interface $aa"
			ifconfig $aa down
		done
	fi
fi

host ${DNSIP} >/dev/null 2>&1 || echo "nameserver ${DNSIP}" >/etc/resolv.conf

for aa in `seq 0 ${RETRY}`
do
	dynip=`host ${DNSNAME}|cut -d" " -f4`
	ethip=`ifconfig ${ETH}|grep "inet addr:"|cut -d: -f2|awk '{print $1}'`

	if [ "${dynip}" != "${ethip}" ]
	then
		[ "${aa}" = "${RETRY}" ] && break
		echo "dns not update yet, update it!"
		ddclient -timeout ${TIMEOUT} -daemon=0 -syslog -use=if -if=${ETH}
		if [  $? = 0 ]
		then			
			echo "dns update to $ethip success! \^^/"
			exit 0
		else
			echo "dns update fail! @@~"
		fi
		sleep ${TIMEWAIT}
	else
		echo "dns updated($ethip)! ^^y"
		exit 0
	fi
done

echo "can not update update dns! Orz"
exit 1

