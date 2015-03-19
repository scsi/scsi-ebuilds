#!/bin/sh
# Thanks to Jan Philipp Giel for the template
# http://www.isis.de/members/~messersch/asus-m6800n.html

# Key Codes Settings
# 00000032=Mute
# 00000030=Volume +1
# 00000031=Volume -1
# 00000040=Skip backwards in XMMS playlist
# 00000043=Stop current song in XMMS
# 00000045=Pause if playing, play otherwise
# 00000041=Skip forward in XMMS playlist
# 0000004c=Eject CDROM
# 00000050=Start Kmail
# 00000051=Mozilla Firebird (Browser)
# 0000005d=Start/Stop WLAN

#. /etc/profile
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/opt/bin:/usr/bin/scsi-useful:/usr/i686-pc-linux-gnu/gcc-bin/3.4.3:/usr/X11R6/bin:/opt/blackdown-jdk-1.4.2.01/bin:/opt/blackdown-jdk-1.4.2.01/jre/bin:/usr/qt/3/bin:/usr/kde/3.3/sbin:/usr/kde/3.3/bin:/opt/vmware/bin:/usr/share/karamba/bin

#user=`ps -aef|grep /etc/X11/Sessions|grep -v grep|awk '{print $1}'`
user=`ps -aef|grep skim|grep -v grep|awk '{print $1}'`

echo `date` \[$user\] $@>>/etc/acpi/hotkey.log
case "$3" in
	00000032)	/usr/bin/amixer set Master toggle
			;;
	00000030)	/usr/bin/amixer set Master 1+
			;;
	00000031)	/usr/bin/amixer set Master 1-
			;;
	00000040)	[ -n "$user" ] && su - $user -c "/usr/bin/xmms -r &"
			;;
	00000043)	[ -n "$user" ] && su - $user -c "/usr/bin/xmms -s &"
			;;
	00000045)	[ -n "$user" ] && su - $user -c "/usr/bin/xmms -t &"
			;;
	00000041)	[ -n "$user" ] && su - $user -c "/usr/bin/xmms -f &"
			;;
	0000004c)	eject /dev/cdrom
			;;
	00000050)	[ -n "$user" ] && su - $user -c "export DISPLAY=:0.0;/usr/bin/mozilla -mail &"
			;;
	00000051)	[ -n "$user" ] && su - $user -c "export DISPLAY=:0.0;/usr/bin/mozilla &"
			;;
	0000005d)	/etc/acpi/wireless.sh &
			;;
	*)		logger "ACPI hotkey $3 is not defined"
			;;
esac
#hotkey ATKD 0000002e 00000000
#hotkey ATKD 0000001f 00000000
#hotkey ATKD 00000034 00000000
#hotkey ATKD 00000061 00000000
#hotkey ATKD 00000061 00000001
#hotkey ATKD 00000061 00000002
#hotkey ATKD 00000061 00000003
#hotkey ATKD 00000033 00000000
#hotkey ATKD 0000006a 00000000

