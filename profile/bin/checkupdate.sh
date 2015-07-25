#!/bin/sh
#set -x

trap "stopprogress;exit 0" 15 1 2 9

TIMEOUT=30s
RETRY=1
. /etc/profile
MAILADDR=scsichen@gmail.com
WORKDIR=/var/lib/checkupdate

unset mailflag
index=1;
add_data()
{
	NAME[$index]="$1"
	URL[$index]="$2"
	PATTERN[$index]="$3"
	index=`expr $index + 1`
}

usage()
{
	echo "Usage: `basename $0` [-m/-M Email@Address] [check [items...]|showdata [items...]|reset [items...]|showurl [items...]|showweb item|list]"
	exit 2
}

progress()
{
	trap "ext=1;exit 0" 15 1 9
	sleep_param=0.05s
	ext=0
	while [ $ext -eq 0 ]
	do
	        echo -e  '\b-\c'
	        sleep $sleep_param
	        echo -e '\b\\\c'
	        sleep $sleep_param
	        echo -e '\b|\c'
	        sleep $sleep_param
	        echo -e '\b/\c'
	        sleep $sleep_param
	done
}

startprogress()
{
	progress&
	ppid=$!
}

stopprogress()
{
	kill -15 $ppid
	wait $swpid
	echo -e '\b\c'
}
w3mpaser(){ sed 's/width/widta/'|w3m -O utf8 -dump -T  text/html -cols 1000|tr -s " "; }
lynxpaser() { lynx -stdin -dump|tr -s " "; }
checkit()
{
	NAME="$1"
	URL="$2"
	PATTERN="$3"

	SUBWORKDIR=$WORKDIR/$NAME
	RAWDATA=$SUBWORKDIR/raw.html
	RAWTEXT=$SUBWORKDIR/raw.txt
	NOWLIST=$SUBWORKDIR/now.list
	ORIGLIST=$SUBWORKDIR/orig.list
	DIFFDATA=$SUBWORKDIR/diff.list
	printf "%-20s:  " "$NAME"
	mkdir -p $SUBWORKDIR

	if [ ! -f $NOWLIST -o "$action" != reset ]
	then
		startprogress
		if wget --no-cache --timeout="$TIMEOUT" -t "$RETRY" -q -O - $URL>$RAWDATA 2>/dev/null
		then
			cat $RAWDATA|w3mpaser >$RAWTEXT
			if [ -n "$PATTERN" ]
			then
				cat $RAWTEXT|(eval $PATTERN)>$NOWLIST
			else
				cat $RAWTEXT >$NOWLIST
			fi
			stopprogress
		else
			stopprogress
			echo "Get information fail."
			return
		fi
	fi

	if [ "$action" = reset ]
	then
		if [ -f $ORIGLIST -a `md5sum $NOWLIST|awk '{print $1}'` = `md5sum $ORIGLIST|awk '{print $1}'` ]
		then
			echo "Unnecessary."
		else
			rm -f $ORIGLIST  >/dev/null 2>&1
			cp $NOWLIST $ORIGLIST >/dev/null 2>&1
			echo "Reset data."
		fi
	else	
		[ -f $ORIGLIST ] || touch $ORIGLIST
		diff -Nu $ORIGLIST $NOWLIST|sed -n 4,\$p >$DIFFDATA
		if [ ${PIPESTATUS[0]} -eq 0 ]
		then
			echo "Up to date."
		else
		       	if [ -n "$mailflag" ]
			then
				echo "Update available, mail to admin"
				printf "subject: Data update - ${NAME}\n\n`cat $DIFFDATA`\r\n"|/usr/lib/sendmail $MAILADDR
			else
				echo "Update available"
				echo "~"
				cat $DIFFDATA
				echo "================================="
			fi
		fi
	fi
}

add_data "XR-3008" "http://conqueror.gpscamera.org/" "grep '台灣目前最新版本'"
add_data "Redmine" "http://www.redmine.org/projects/redmine/wiki/Download" "awk '/Latest releases/,/Resources/'|grep -v -e : -e '^$'"
add_data "Eclipse" "https://eclipse.org/downloads/" "grep 'Release for'"
add_data "Jenkins" "https://jenkins-ci.org/" "grep 'Latest and greatest'"
#add_data "Docker" "https://docs.docker.com/release-notes/" "grep 'Release Notes Version'"
add_data "Slf4j" "http://www.slf4j.org/download.html" "grep '.zip$'"
add_data "Logback" "http://logback.qos.ch/download.html" "grep '.zip$'"
add_data "Log4j" "http://logging.apache.org/log4j/2.x/download.html" "grep 'Apache Log4j 2 binary (zip)'"
add_data "Tomcat" "http://tomcat.apache.org" "grep 'Tomcat.*Released'"
add_data "Tomcat_JK" "http://tomcat.apache.org/connectors-doc" "grep 'JK.*released'"

#add_data "GPS9900" "http://www.tw-radar.com.tw/tech/file/upfile_list.asp" "GPS.*9900.*?x?W"
#add_data "GPS9968" "http://www.5685.com.tw/default.php" "?x?W??"
#add_data "Mobile01" "http://www.mobile01.com/downloads.php" "???s??"
#add_data "Garmin350" "http://www.garmin.com.tw/products/Nuvi350_TWN/download.htm" ""
#add_data "Garmin" "http://www.garmin.com.tw/support/download.htm" "\(MapSource\|Nuvi 350\|USB\).*[0-9][0-9]/[0-9][0-9]/[0-9][0-9]"
#add_data "Gcin" "http://cle.linux.org.tw/gcin/download" "gcin.*\.tar\."
#add_data "PCManX" "http://pcmanx.csie.net" "pcmanx-gtk2.*\.tar\."
#add_data "SMPlayer" "http://kde-apps.org/content/show.php/SMPlayer?content=54487" "Version:"
#add_data "smplayer-theme" "http://smplayer.sourceforge.net/downloads.php?tr_lang=en" "smplayer-.*\.tar\."
#add_data "KDMTheme" "http://kde-apps.org/content/show.php/KDM+Theme+Manager?content=22120" "Version:"
#add_data "KSquirrel" "http://kde-apps.org/content/show.php/KSquirrel?content=12317" "Version:"
#add_data "Yakuake" "http://kde-apps.org/content/show.php/Yakuake?content=29153" "Version:"
#add_data "KSniffer" "http://kde-apps.org/content/show.php/KSniffer?content=26258" "Version:"
#add_data "QStarDict" "http://qstardict.ylsoftware.com" "latest version"
#add_data "KGtk" "http://kde-apps.org/content/show.php/KGtk+%28Use+KDE+Dialogs+in+Gtk+Apps%29?content=36077" "Version:"
#add_data "GPicView" "http://sourceforge.net/project/showfiles.php?group_id=180858" "Latest"
#add_data "Stardict" "http://stardict.sourceforge.net/other.php" "Source code package"
#add_data "Sdcv" "http://stardict.sourceforge.net/other.php" "Command line version"
#add_data "scim-array" "http://scimarray.openfoundry.org/" "?ثe?̷s????"
#add_data "scim-chewing" "http://chewing.csie.net/download/scim/" "scim-chewing"
#add_data "libchewing" "http://chewing.csie.net/download/libchewing/" "libchewing"
#add_data "pcmanfm" "http://sourceforge.net/project/showfiles.php?group_id=156956" "Latest"
#add_data "antcontrib" "http://sourceforge.net/projects/ant-contrib/files/ant-contrib" "Latest"
#add_data "gtkhirad" "http://pcman.sayya.org/gtkhirad" "gtkhirad"
#add_data "kalsamix" "http://sourceforge.net/project/showfiles.php?group_id=194230" "Latest"
#add_data "autostart" "http://beta.smileaf.org/files/autostart" "autostart"
#add_data "kwlan" "http://home.arcor.de/tom.michel/downloads.html" "Version"
#add_data "kwirelessmonitor" "http://www.cs.cmu.edu/~pach/kwirelessmonitor/" "Source"
#add_data "wlassistant" "http://sourceforge.net/project/showfiles.php?group_id=134488" "Latest"
#add_data "hinedo" "http://rt.openfoundry.org/Foundry/Project/?Queue=814" "New release"
#add_data "Kirocker" "http://www.kde-apps.org/content/show.php?content=52869" "Version:"
#add_data "imageshack-upload" "http://kde-apps.org/content/show.php?content=51247" "Version:"
#add_data "kconnections" "http://kde-apps.org/content/show.php?content=71204" "Version:"
#add_data "CDFS" "http://trappist.elis.ugent.be/~mronsse/cdfs/download/" "cdfs.*"
#add_data "Gmail-Notify" "http://sourceforge.net/project/showfiles.php?group_id=125937" "Latest"
#add_data "KGmail-Notify" "http://www.kde-apps.org/content/show.php/KGmailNotifier?content=55375" "Version:"

set -- `getopt mM: $*||usage` 
for i
do
	case "$i" in
		-m)
			mailflag=mail;shift;;
		-M)
			mailflag=mail;
			MAILADDR=$2
			shift;shift;;
		--)
			shift; break;;
	esac
done
action=$1;shift
items=( $@ )

[ -z "$items" -o -z "$action" ] && items=( ${NAME[@]} )

[ -n "${mailflag}" ] && { echo $MAILADDR|grep -e "^[a-zA-Z_0-9-]\+\(\.[a-zA-Z_0-9-]\+\)*@[a-zA-Z_0-9-]\+\(\.[a-zA-Z_0-9-]\+\)\+$" >/dev/null 2>&1||{ echo "email $MAILADDR not valid."; exit 1; } }

case "$action" in
	reset|""|check)
		#for ((i=1; i<=12; i++))
		for item in ${items[@]}
		do
			no=1
			thisno=0
			while [ -n "${NAME[$no]}" ]
			do
				if echo ${NAME[$no]}|grep -i "^$item$" >/dev/null 2>&1 
				then
					thisno=$no
					break;
				fi
				no=`expr $no + 1`
			done
			if [ $thisno -gt 0 ]
			then
				checkit "${NAME[$thisno]}" "${URL[$thisno]}" "${PATTERN[$thisno]}"
			else
				echo $item: Not valid.
			fi
		done
		;;
	list)
		[ -n "$1" ] && usage
		no=1
		while [ -n "${NAME[$no]}" ]
		do
			echo "${NAME[$no]}"
			no=`expr $no + 1`
		done
		;;
	showdata)
		for item in ${items[@]}
		do
			no=1
			thisno=0
			while [ -n "${NAME[$no]}" ]
			do
				if echo ${NAME[$no]}|grep -i "^$item$" >/dev/null 2>&1 
				then
					thisno=$no
					break;
				fi
				no=`expr $no + 1`
			done
			if [ $thisno -gt 0 ]
			then
				SUBWORKDIR=$WORKDIR/${NAME[$thisno]}
				RAWDATA=$SUBWORKDIR/raw.html
				NOWLIST=$SUBWORKDIR/now.list
				ORIGLIST=$SUBWORKDIR/orig.list
				DIFFDATA=$SUBWORKDIR/diff.list
				echo ${NAME[$thisno]}:
				echo "~"
				cat $ORIGLIST
				echo "================================="
			else
				echo $item: Not valid.
			fi
		done
		;;
	showurl)
		for item in ${items[@]}
		do
			no=1
			thisno=0
			while [ -n "${NAME[$no]}" ]
			do
				if echo ${NAME[$no]}|grep -i "^$item$" >/dev/null 2>&1 
				then
					thisno=$no
					break;
				fi
				no=`expr $no + 1`
			done
			if [ $thisno -gt 0 ]
			then
				echo $item: ${URL[${thisno}]}
			else
				echo $item: Not valid.
			fi
		done
		;;
	showweb)
		[  ${#items[@]} -ne 1 ] && usage
		no=1
		thisno=0
		item=${items[0]}
		while [ -n "${NAME[$no]}" ]
		do
			if echo ${NAME[$no]}|grep -i "^$item$" >/dev/null 2>&1 
			then
				thisno=$no
				break;
			fi
			no=`expr $no + 1`
		done
		if [ $thisno -gt 0 ]
		then
			w3m ${URL[${thisno}]}
		else
			echo $item: Not valid.
		fi
		;;
	*) 
		usage;;
esac

