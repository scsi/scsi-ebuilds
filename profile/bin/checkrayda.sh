#!/bin/sh
. /etc/profile
MAILADDR=scsichen@gmail.com
WORKDIR=/tmp/checkrayda
param=$1

checkGPS()
{
	WORKDIR_GPS=$WORKDIR/$GPS
	RAWDATA=$WORKDIR_GPS/raw.html
	NOWLIST=$WORKDIR_GPS/now.list
	ORIGLIST=$WORKDIR_GPS/orig.list
	DIFFDATA=$WORKDIR_GPS/diff.list
	if [ "$param" = reset ]
	then
		rm -rf $ORIGLIST
	fi
	mkdir -p $WORKDIR_GPS
	if wget -q -O - $URL>$RAWDATA 2>/dev/null
	then
		if [ -n "$KEYWORD" ]
		then
			cat $RAWDATA|sed 's/width/widta/'|w3m -O big5 -dump -T  text/html -cols 1000|grep -e "$KEYWORD" |tr -s " ">$NOWLIST
		else
			cat $RAWDATA|sed 's/width/widta/'|w3m -O big5 -dump -T  text/html -cols 1000 |tr -s " ">$NOWLIST
		fi
		[ -f $ORIGLIST ]  || cp $NOWLIST $ORIGLIST
		diff -Nu $ORIGLIST $NOWLIST >$DIFFDATA
		if [ $? -eq 0 ] 
		then
			echo "$GPS data has updated."
		else
		       	#printf "subject: GPS-9900 data update\r\n `cat $DIFFDATA`\r\n"|/usr/lib/sendmail $MAILADDR
		       	if [ "$param" = mail ]
			then
				
				echo "$GPS data update, mail to admin"
				printf "subject: $GPS data update\n\n`cat $DIFFDATA`\r\n"|/usr/lib/sendmail $MAILADDR
			else
				echo "$GPS data update"
				echo "================================="
				cat $DIFFDATA
				echo "================================="
			fi
		fi
	fi
}
checkGPS9900()
{
	#URL=http://www.tw-radar.com.tw/tech/file/upfile_list.asp
	URL="http://www.tw-radar.com.tw/tech/file/upfile_list.asp?n_team=&page=2"
	GPS=GPS9900
	KEYWORD="GPS.*9900.*台灣"
	checkGPS
}
checkGPS9968()
{
	URL=http://www.5685.com.tw/default.php
	GPS=GPS9968
	KEYWORD=台灣版
	checkGPS
}
checkMobile01()
{
	URL=http://www.mobile01.com/downloads.php
	GPS=Mobile01
	KEYWORD=更新日
	checkGPS
}
checkGarmin350()
{
	URL=http://www.garmin.com.tw/products/Nuvi350_TWN/download.htm
	GPS=Garmin350
	KEYWORD=""
	checkGPS
}
checkGarmin()
{
	URL=http://www.garmin.com.tw/support/download.htm
	GPS=Garmin
	KEYWORD="\(MapSource\|Nuvi 350\|USB\).*[0-9][0-9]/[0-9][0-9]/[0-9][0-9]"
	checkGPS
}
checkGcin()
{
	URL=http://cle.linux.org.tw/gcin/download
	GPS=Gcin
	KEYWORD="gcin.*\.tar\."
	checkGPS
}
checkPCManX()
{
	URL=http://pcmanx.csie.net
	GPS=PCManX
	KEYWORD="pcmanx-gtk2.*\.tar\."
	checkGPS
}
checkSMPlayer()
{
	URL="http://kde-apps.org/content/show.php/SMPlayer?content=54487"
	GPS=SMPlayer
	KEYWORD="Version:"
	checkGPS
}
checkKDMTheme()
{
	URL="http://kde-apps.org/content/show.php/KDM+Theme+Manager?content=22120"
	GPS=KDMTheme
	KEYWORD="Version:"
	checkGPS
}
checkKSquirrel()
{
	URL="http://kde-apps.org/content/show.php/KSquirrel?content=12317"
	GPS=KSquirrel
	KEYWORD="Version:"
	checkGPS
}
checkYakuake()
{
	URL="http://kde-apps.org/content/show.php/Yakuake?content=29153"
	GPS=Yakuake
	KEYWORD="Version:"
	checkGPS
}
checkKSniffer()
{
	URL="http://kde-apps.org/content/show.php/KSniffer?content=26258"
	GPS=KSniffer
	KEYWORD="Version:"
	checkGPS
}
checkGPS9900
checkGPS9968
checkMobile01
checkGarmin
checkGarmin350
checkGcin
checkPCManX
checkSMPlayer
checkKDMTheme
checkKSquirrel
checkYakuake
checkKSniffer

