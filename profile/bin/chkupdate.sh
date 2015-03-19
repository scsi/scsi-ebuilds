#!/bin/sh
#set -x

#trap "echo stoping `basename $0` ; (ps -aef|awk \"{if (\$3 == $$) print \$2}\"|xargs kill) 1>/dev/null 2>&1 ; exit 1" 1 2 9 15
trap "echo stoping `basename $0` ; INTERRUP=1 ; (ps -aef|awk \"{if (\$3 == $$) print \$2}\"|xargs kill) 1>/dev/null 2>&1" 1 2 9 15

INTERRUP=0
TIMEOUT=30s
RETRY=1
. /etc/profile
MAILADDR=yc.chen@infoexplorer.com.tw
WORKDIR=/var/lib/checkupdate

unset mailflag
index=1
MAXNAMELEN=0

pscount()
{
        cnt=`ps -aef|awk '{print $3}'|grep $$|wc -l`
        expr $cnt - 1
}

waitpsc()
{
        while [ `pscount` -ge $1 ]
        do
                sleep 1
        done
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

checkit()
{
	trap "(ps -aef|awk \"{if (\$3 == $$) print \$2}\"|xargs kill) 1>/dev/null 2>&1; exit 1" 1 2 9 15

	local NAME
	local URL
	local IFS
	NAME=$1 ; shift
	URL=$1 ; shift
	IFS=","
	for opt in $@
	do
		opt=`echo $opt|sed -s "s/(^ *)|( *$)//"`
		echo $opt|grep -q "^[^=][^=]*=..*" || { echo \"$opt\" is not vaild.; continue; }
		local `echo $opt|cut -d= -f1`
		eval $opt
	done
	
	[ -z "$PATTERN" ] && PATTERN="."
	[ -z "$HTTPPROG" ] && HTTPPROG="w3m"

	SUBWORKDIR=$WORKDIR/$NAME
	RAWDATA=$SUBWORKDIR/raw.html
	NOWLISTTMP=$SUBWORKDIR/now.list.tmp
	NOWLIST=$SUBWORKDIR/now.list
	ORIGLIST=$SUBWORKDIR/orig.list
	DIFFDATA=$SUBWORKDIR/diff.list
	mkdir -p $SUBWORKDIR

	#NAME="$1"
	#URL="$2"
	#PATTERN="$3"
	#GREPOPT="$4"
	#HTTPPROG="$5"
	#SEDOPT="$6"
	#AWKOPT="$7"

	if [ ! -f $NOWLIST -o "$action" != reset ]
	then
		if wget --no-cache --timeout="$TIMEOUT" -t "$RETRY" -q -O - $URL>$RAWDATA 2>/dev/null
		then
			if [ `ls -s $RAWDATA|awk '{print $1}'` -eq 0 ]
			then
				printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Get zero data."
				return
			fi
			case "$HTTPPROG" in
			lynx)
				HTEXT=`cat $RAWDATA|lynx -stdin -dump`;;
			*)
				HTEXT=`cat $RAWDATA|sed 's/width/widta/'|w3m -O utf8 -dump -T  text/html -cols 1000`;;
			esac
			cmd='echo "$HTEXT"|grep $GREPOPT -e "$PATTERN"|tr -s " " '
			[ -n "$SEDOPT" ]&&cmd=$cmd'|sed "$SEDOPT"'
			[ -n "$AWKOPT" ]&&cmd=$cmd'|awk "$AWKOPT"'
			eval "$cmd>$NOWLISTTMP"
			mv -f $NOWLISTTMP $NOWLIST >/dev/null 2>&1
		else
			rtn=$?
			printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Get information fail [wget errno: $rtn]."
			return
		fi
	fi


	if [ "$action" = reset ]
	then
		if [ -f $ORIGLIST -a "`md5sum $NOWLIST|awk '{print $1}'`" = "`md5sum $ORIGLIST|awk '{print $1}'`" ]
		then
			#printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Reset unnecessary."
			:
		elif [ ! -s $NOWLIST ]
		then
			printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "empty data. skip it."
		else
			rm -f $ORIGLIST  >/dev/null 2>&1
			cp $NOWLIST $ORIGLIST >/dev/null 2>&1
			printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Reset data."
		fi
	else
		[ -f $ORIGLIST ]  || cp $NOWLIST $ORIGLIST
		if diff -Nu $ORIGLIST $NOWLIST >$DIFFDATA
		then
			#printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Up to date."
			[ -s $ORIGLIST ] || printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "WARNING: orignal data is empty."
			:
		else
		       	if [ -n "$mailflag" ]
			then
				printf "%-${MAXNAMELEN}s: %s\n" "$NAME" "Update available, mail to admin"
				printf "subject: Data update - ${NAME}\n\n`echo $URL;cat $DIFFDATA`\r\n"|/usr/lib/sendmail $MAILADDR
			else
				printf "%-${MAXNAMELEN}s: %s\n%s\n%s\n%s\n" "$NAME" "Update available" "=================================" "`echo $URL;cat $DIFFDATA`" "================================="
			fi
		fi
	fi
}

add_data()
{
	[ `printf "$1"|wc -c` -gt $MAXNAMELEN ] && MAXNAMELEN=`printf "$1"|wc -c`
	NAME[$index]="$1"
	URL[$index]="$2"
	OPT[$index]="$3"
	index=`expr $index + 1`
}

add_data_kdelook()
{
	add_data "$1" "http://kde-look.org/content/show.php?content=$2" "HTTPPROG='lynx',GREPOPT='-A 2',PATTERN='^$3$'"
}

add_data_kdeapps()
{
	add_data "$1" "http://kde-apps.org/content/show.php?content=$2" "HTTPPROG='lynx',GREPOPT='-A 2',PATTERN='^$3$'"
}

add_data_opendesktop()
{
	add_data "$1" "http://opendesktop.org/content/show.php?content=$2" "HTTPPROG='lynx',GREPOPT='-A 2',PATTERN='^$3$'"
}

add_data_coolapk()
{
	add_data "$1" "http://www.coolapk.com/$2/" "PATTERN='酷安网 >'"
}

add_data_googlecode()
{
	add_data "$1" "http://code.google.com/p/$2/downloads/list" "PATTERN='dl_arrow.gif',HTTPPROG='lynx',AWKOPT='BEGIN {FS = \"\\\\]|\\\\[\"} { print \$7}'"
}

add_data_sourceforge()
{
	#add_data "$1" "http://sourceforge.net/projects/$2/files/" "PATTERN='Download',SEDOPT='s/^.*Download//'"
	add_data "$1" "http://sourceforge.net/projects/$2/files/$3"  "PATTERN='downloads',SEDOPT='s/ [^ ]* [^ ]* downloads//'"
}

add_data_openfoundry()
{
	add_data "$1" "http://www.openfoundry.org/of/projects/$2/download" "PATTERN='顯示/隱藏詳細資訊',GREPOPT='-A 1'"
}

add_data_android()
{
	add_data "$1" "https://market.android.com/details?id=$2" "PATTERN='目前版本：',GREPOPT='-A 1'"
}
add_data "XR-3008" "http://conqueror.gpscamera.org/" "PATTERN='^台灣',GREPOPT='-A 1'"
add_data "garmin-extra" "http://www.garmin.com.tw/m/buzz/tw/exclusive"
add_data "GPS9900" "http://www.tw-radar.com.tw/tech/file/upfile_list.asp?n_team=&page=1" "PATTERN='GPS.*9900.*台灣'"
add_data "GPS9968" "http://www.5685.com.tw" "PATTERN='台灣'"
#add_data "GPS-GP1" "http://www.ghtc.com.tw/FileDownLoad/FileDownLoadHtml.aspx" "PATTERN='台灣',HTTPPROG='lynx'"
add_data "Garmin765" "http://www.garmin.com.tw/products/car/nuvi765/#updateTab" "PATTERN='Download'"
add_data "PGP116N" "http://tw.aximcom.com/tw/support/downloads-/cat_view/87-/60-p2p-gear-pro-/96-pgp-116n.html" "PATTERN='韌體',SEDOPT='s/Hits:.*$//'"


add_data "groovy" "http://groovy.codehaus.org/Download" "PATTERN='^Groovy'"
add_data "oracle-oepe" "http://www.oracle.com/technetwork/developer-tools/eclipse/downloads/index.html" "PATTERN='Oracle Enterprise Pack for Eclipse'"
add_data "weblogic" "http://www.oracle.com/technetwork/middleware/fusion-middleware/downloads/index.html" "PATTERN='Oracle WebLogic Server'"
add_data "slf4j" "http://www.slf4j.org/dist/" "PATTERN='slf4j',AWKOPT='BEGIN {FS = \"/\"} /file:\/\/localhost\/tmp/  {print \$6}',HTTPPROG='lynx'"
add_data "spring" "http://www.springsource.org/download/community" "PATTERN='Spring.* release'"
add_data "primefaces" "http://www.primefaces.org/downloads.html" "PATTERN='primefaces.*\.jar'"
add_data "logback" "http://logback.qos.ch/download.html" "PATTERN='logback.*\(\.zip\)\|\(\.tar.gz\)$'"
#add_data "logback" "http://logback.qos.ch/dist/" "PATTERN='logback-q',AWKOPT='{print \$3}'"
add_data "git" "http://git-scm.com/" "PATTERN='\(v[0-9][0-9]*\.\)\|\(release notes\)'"
add_data "compiz" "http://wiki.compiz.org/" "PATTERN='released'"

add_data "Gcin" "http://www.csie.nctu.edu.tw/~cp76/gcin/download" "PATTERN='gcin.*\.tar\.'"
add_data "hime" "http://hime.luna.com.tw" "PATTERN='hime.*\.tar\.',AWKOPT='{print \$3}'"
add_data "oxim" "ftp://ftp.opendesktop.org.tw/odp/others/OXIM/Source/tarball/" "PATTERN='oxim.*\.tar\.'"
add_data "QStarDict" "http://qstardict.ylsoftware.com" "PATTERN='latest version'"
add_data "scim-chewing" "http://chewing.csie.net/download/scim/" "PATTERN='scim-chewing'"
add_data "libchewing" "http://chewing.csie.net/download/libchewing/" "PATTERN=libchewing"
add_data "CDFS" "http://trappist.elis.ugent.be/~mronsse/cdfs/download/" "PATTERN='cdfs.*'"
add_data "eclipse" "http://download.eclipse.org/eclipse/downloads/" "PATTERN='\(Stream Stable Build\)\|\(Latest Release\)'"
add_data "eclipse3" "http://download.eclipse.org/eclipse/downloads/eclipse3x.php" "PATTERN='\(Stream Stable Build\)\|\(Latest Release\)'"

add_data_googlecode "minicm" "minicm"
add_data_googlecode "ibus" "ibus"
add_data_googlecode "gtk-qt-engine" "gtk-qt-engine"
add_data_googlecode  "PCManX" "pcmanx-gtk2"
add_data_googlecode "Stardict" "stardict-3"

add_data_sourceforge "ShellED" "shelled" "shelled"
add_data_sourceforge "jxplorer" "jxplorer" "jxplorer"
add_data_sourceforge "winscp" "winscp" "WinSCP"
add_data_sourceforge "itext" "itext" "iText"
#add_data "smplayer-theme" "http://smplayer.sourceforge.net/downloads.php?tr_lang=en" "smplayer-.*\.tar\."
add_data_sourceforge "smplayer" "smplayer" "SMPlayer"
add_data_sourceforge "smplayer-theme" "smplayer" "SMPlayer-themes"
#add_data "Sdcv" "http://sdcv.sourceforge.net/" "sdcv.*\.tar.*"
add_data_sourceforge "Sdcv" "sdcv" "sdcv"
#add_data "scim" "http://www.scim-im.org/downloads/scim_download" "Version"
add_data_sourceforge "scim" "scim" "scim"
add_data_sourceforge "skim" "scim" "skim"
add_data_sourceforge "EclEmma" "eclemma" "01_EclEmma_Releases"

add_data_openfoundry "scim-array" "830"
add_data_openfoundry "tongwen" "333"

add_data_kdeapps "RSIBreak" "29725" "RSIBreak"
add_data_kdeapps "KOSD" "81457" "KOSD"
add_data_kdeapps "kopete-psyko" "121585" "kopete psyko"
add_data_kdelook "plasma-gmail-plasmoid" "101229" "gmail-plasmoid"
add_data_kdelook "plasma-countdown" "74950" "countdown"
add_data_kdelook "plasma-flickrop" "94800" "Flickr On Plasma"
add_data_kdelook "plasma-flickrplasmoid" "83246" "Flickr Plasmoid"
add_data_kdelook "plasma-netgraph" "74071" "plasma-netgraph"
add_data_kdelook "plasma-playwolf" "93882" "PlayWolf"
add_data_kdelook "plasma-quicklauncher" "78061" "QuickLauncher Applet"
add_data_kdelook "plasma-systemmonitor" "94746" "SystemMonitorNG"
add_data_kdelook "plasma-weatherforecast" "92149" "simple weather forecast"
add_data_kdelook "plasma-yawp" "94106" "yaWP (Yet Another Weather Plasmoid)"
add_data_kdelook "plasma-stasks" "99739" "STasks"
add_data_kdelook "plasma-nvidia-sensors" "87195" "Nvidia sensors monitor"
add_data_kdelook "yasp-scripted" "109367" "Yasp-Scripted (Systemmonitor).*"
add_data_kdelook "plasma-crystal-monitor" "28165" "Crystal Monitor"
add_data_kdelook "plasma-oxygen-monitor" "86664" "Oxygen System Monitor"
add_data_kdelook "plasma-custom-weather" "98925" "Customizable Weather Plasmoid (CWP)"
add_data_kdelook "plasma-system-status" "74891" "System Load Viewer" 
add_data_kdelook "plasma-mail" "98952" "mail_plasmoid"
add_data_kdelook "plasma-gmail-notifier" "99709" "Gmail Notifier"
add_data_kdelook "plasma-quickaccess" "98521" "Quickaccess for KDE 4.2"
add_data_kdelook "plasma-fancytasks" "99737" "Fancy Tasks"
add_data_kdelook "plasma-wallpaper-weather" "102185" "Weather Wallpaper Plugin"
add_data_kdelook "plasma-gmail-plasmoid" "101229" "gmail-plasmoid"
add_data_kdelook "plasma-magic-folder" "100348" "Magic Folder"
add_data_kdelook "plasma-devicemanager" "106051" "Device Manager"
add_data_kdelook "plasma-applet-luna2" "100337" "Luna 2"
add_data_kdelook "rssremix" "102542" "rssremix"
add_data_kdelook "geek-clock-plasmoid" "107807" "Geek Clock"
add_data_kdelook "starfield-wallpaper" "105973" "Star Field Plasma Wallpaper"
add_data_kdelook "Meniny" "108173" "Meniny (Slovakian name-day)"
add_data_kdelook "QtCurve" "40492" "QtCurve .* Theme)"
add_data_kdelook "AnalogMeter" "111651" "Analog Meter"
add_data_kdelook "AnimatedVideoWallpaper" "112105" "Animated Video Wallpaper"
add_data_kdelook "SmoothTasks" "101586" "Smooth Tasks"
add_data_kdelook "scripted-image" "91749" "Scripted Image"
add_data_kdelook "tuxeyes" "120161" "Tux Eyes"
add_data_kdelook "socketsentry" "122350" "Socket Sentry"

add_data_opendesktop "knemo" "12956" "KNemo"
add_data_opendesktop "wicd-client-kde" "132366" "Wicd Client KDE"

add_data_kdeapps "KGtk" "36077" "KGtk (Use KDE Dialogs in Gtk Apps)"
add_data_kdeapps "kconnections" "71204" "KConnections"
add_data_kdeapps "imageshack-upload" "51247" "Host on Imageshack"
add_data_kdeapps "MPlayerThumbs" "41180" "MPlayerThumbs"
add_data_kdeapps "Yakuake" "29153" "Yakuake"
add_data_kdeapps "KSniffer" "26258" "KSniffer"
add_data_kdeapps "gtk-kde4" "74689" "gtk-kde4"

add_data_coolapk "systemapp-remover" "apk-3200-com.danesh.system.app.remover"
add_data_coolapk "1-vpn" "apk-3132-com.doenter.onevpn"
add_data_coolapk "camera360" "apk-1469-vStudio.Android.GPhotoPaid"
add_data_coolapk "fancy-widgets" "apk-3754-com.anddoes.fancywidgets"
add_data_coolapk "poweramp" "apk-3163-com.maxmpz.audioplayer"
add_data_coolapk "multimount-sdcard" "apk-2957-com.rafoid.multimountsdcard.widget"
add_data_coolapk "photaf" "apk-3037-obg1.PhotafPro"
add_data_coolapk "root-explorer" "apk-1229-com.speedsoftware.rootexplorer"
add_data_coolapk "ultimate-voicerecord" "apk-2756-com.fingertipaccess.ultimatevr"
add_data_coolapk "camcard" "apk-1286-com.intsig.BizCardReader"
add_data_coolapk "adw-ex" "apk-3381-org.adwfreak.launcher"
add_data_coolapk "fakecall" "apk-1318-com.agilestorm.fakecall.pro"
add_data_coolapk "panorama" "apk-4333-com.occipital.panorama"
add_data_coolapk "mp3recorder" "apk-4293-yuku.mp3recorder.full"
add_data_coolapk "pano" "apk-4341-com.debaclesoftware.pano"
add_data_coolapk "callrecorder" "apk-4110-com.skvalex.callrecorder"
add_data_coolapk "app2sd" "apk-3514-com.a0soft.gphone.app2sd.pro"
add_data_coolapk "smart-tool" "apk-3728-kr.aboy.tools"

add_data_android "superclock" "mx.livewallpaper.clock"

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
				if [ ! "$action" = "reset" ]
				then
					if [ "$INTERRUP" -eq 1 ]
					then
						childprocess=`ps -aef|awk "{if (\\$3 == $$) print \\$2}"`
						echo kill $childprocess
						kill $childprocess
						break
					fi
						waitpsc 6
						checkit "${NAME[$thisno]}" "${URL[$thisno]}" "${OPT[$thisno]}" &
				else
					checkit "${NAME[$thisno]}" "${URL[$thisno]}" "${OPT[$thisno]}"
				fi
			else
				echo $item: Not valid.
			fi
		done
		while [ 1 = 1 ]
		do
			sleep 0.1
			pscontent=`ps -aef |awk "{if (\\$3==\"$$\") print \\$0}"`
			pscontent=`echo "$pscontent"|grep -v -e grep -e ps -e awk`
			[ `echo "$pscontent"|wc -l` -le 1 ] && break;
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
				echo "================================="
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

