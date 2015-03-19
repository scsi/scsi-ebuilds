#!/bin/sh
. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"

#echo "`date +%D-%T`	check vpn." >> /tmp/checkvpn.log
if [ "`/etc/init.d/vpn.scsihome --nocolor status|awk '{print $3}'`" = started ]
then
	for tm in `seq 1 5`
	do
		ping -c 1 scsihome &>/dev/null && exit 0
		echo "`date +%D-%T`     restart vpn	[$tm]." >> /tmp/checkvpn.log
		/etc/init.d/vpn.scsihome stop
		/etc/init.d/vpn.scsihome start
		sleep 20
	done
#else
#	echo "`date +%D-%T`     skip check vpn." >> /tmp/checkvpn.log
fi
