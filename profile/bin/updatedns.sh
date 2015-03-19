#!/bin/sh
#[ $# -ne 3 ] && exit 1
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/kde/3.5/bin/:$HOME/bin
if [ $# -eq 0 ]
then
	IF=ppp0
	IP=unknow
	ACTION=UP
else
	IF=$1
	IP=$2
	ACTION=$3
fi

case $ACTION in
up|UP)	
 	play /home/scsi/storeroom/sound/icq.wav/Homepage.wav
	artsdsp play /home/scsi/storeroom/sound/icq.wav/Homepage.wav
	#echo "`date '+%Y/%m/%d-%H:%M:%S'`	$IF/$IP	UP" >>/var/log/ppp.log;;
	logger -t updatedns "$IF/$IP	UP";;
down|DOWN)
	play /home/scsi/storeroom/sound/icq.wav/icqcheck.wav
	artsdsp play /home/scsi/storeroom/sound/icq.wav/icqcheck.wav
	logger -t updatedns "$IF/$IP	DOWN";;
*)
	logger -t updatedns "$IF/$IP	$ACTION";;
esac

if [ "$ACTION" = "up" -o "$ACTION" = "UP" ]
then
	case "$IP" in
	10.*)           ;;
	172.1[6-9].* | 172.2[0-9].* | 172.31.*) ;;
	192.168.*)      
				route del -host 140.92.4.91
				route del -net 140.92.0.0 netmask 255.255.0.0
				route del -net 192.168.11.0 netmask 255.255.255.0
				route add -host 140.92.4.91 ppp0
				route add -net 140.92.0.0 netmask 255.255.0.0 gw scsioffice
				#route add -net 192.168.0.0 netmask 255.255.0.0 gw scsioffice
				echo "1" > /proc/acpi/asus/mled
        	        ;;
	*)             	(
                                sleep 5
				[ -f /home/root/bin/updatetime.sh ] && /home/root/bin/updatetime.sh
				[ -f /root/bin/updatetime.sh ] && /root/bin/updatetime.sh
                                ddclient -daemon=0 -syslog -use=if -if=$IF >/dev/null 2>&1 
                                logger -t adsl "adsl up [$IF/$IP]"
			)&
			;;
	esac

elif [ "$ACTION" = "down" -o "$ACTION" = "DOWN" ]
then
	case "$IP" in
	10.*)           ;;
	172.1[6-9].* | 172.2[0-9].* | 172.31.*) ;;
	192.168.*)      
				route del -host 140.92.4.91
				route del -net 140.92.0.0 netmask 255.255.0.0
				route del -net 192.168.0.0 netmask 255.255.0.0
				echo "0" > /proc/acpi/asus/mled
				echo "0" > /proc/acpi/asus/mled
				echo "0" > /proc/acpi/asus/mled
        	        ;;
	*)             	(
				logger -t updatedns "adsl down [$IF/$IP]"
			)&
			;;
	esac
fi
