#!/bin/sh
#set -x

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

TIME_SERVER="time.stdtime.gov.tw
clock.stdtime.gov.tw
tick.stdtime.gov.tw
tock.stdtime.gov.tw
watch.stdtime.gov.tw
2.tw.pool.ntp.org
1.asia.pool.ntp.org
3.asia.pool.ntp.org"
#[ "$HOSTNAME" = scsioffice -o "$HOSTNAME" = risnw002 ] && TIME_SERVER=192.168.155.234 

for tserver in $TIME_SERVER
do
	printf "$tserver: "
	#if ntpdate -s $tserver
	if ntpdate $tserver
	then
		hwclock -w >/dev/null 2>&1
		break
	else
		echo "update time error!"
		exit 1
	fi
done
exit 0
