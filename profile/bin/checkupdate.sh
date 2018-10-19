#!/bin/sh
#set -x

trap "stopprogress;exit 0" 15 1 2 9

#export http_proxy=http://bqproxy.iet:3128
#export https_proxy=http://bqproxy.iet:3128
#export ftp_proxy=http://bqproxy.iet:3128


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

progress() {
	trap "ext=1;exit 0" 15 1 9
	local sleep_param=0.05s;local n=0
	local pchars=(- \\\\ '|' / )
	while true;do
		sleep 0.1s;((n++));((n%=4));echo -e "\b${pchars[$n]}\c"
	done
}

startprogress() { progress& _progress_pid=$!;  }
stopprogress() { kill -15 $_progress_pid; wait $_progress_pid; echo -e '\b\c'; }
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
	printf "%-30s:  " "$NAME"
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
				printf "subject: Data update - ${NAME}\n\n$URL\n\n~\n\n`cat $DIFFDATA`\r\n"|/usr/lib/sendmail $MAILADDR
			else
				echo "Update available"
				echo "~"
				echo $URL
				echo "~"
				cat $DIFFDATA
				echo "================================="
			fi
		fi
	fi
}

add_data_mvnrepo(){
  #add_data "$1" "http://mvnrepository.com/artifact/$2" " grep '^[[:blank:]]*[0-9].*[[:blank:]][0-9][0-9]*[[:blank:]]'|awk '{print \$(NF-4),\$(NF-2),\$(NF-1),\$(NF);}'"
  #add_data "$1" "http://mvnrepository.com/artifact/$2" " grep '^[[:blank:]]*[0-9].*[[:blank:]][0-9][0-9]*[[:blank:]]'|sed 's/[0-9][A-Za-z0-9\.]*\.x *//'|awk '{print \$(NF-4),\$(NF-2),\$(NF-1),\$(NF);}'"
  add_data "$1" "http://mvnrepository.com/artifact/$2" " grep '^[[:blank:]]*[0-9].*[[:blank:]][0-9][0-9]*[[:blank:]]'|sed 's/[0-9][A-Za-z0-9\.]*\.x *//'|awk '{print \$(NF-4);}'"
}

add_data "XR-3008" "http://conqueror.gpscamera.org/" "grep '台灣目前最新版本'"
add_data "Redmine" "http://www.redmine.org/projects/redmine/wiki/Download" "awk '/Latest releases/,/Resources/'|grep -v -e : -e '^$'"
add_data "Eclipse" "https://eclipse.org/downloads/eclipse-packages" "grep 'Release for'"
add_data "Jenkins" "https://jenkins.io/download/" "grep 'Download Jenkins .*for:'"
#add_data "Docker" "https://docs.docker.com/release-notes/" "grep 'Release Notes Version'"
add_data "docker" "https://github.com/docker/docker-ce/releases" "grep '^v'"
add_data "docker-registry" "https://github.com/docker/distribution/releases" "grep '• v'"
add_data "containerd" "https://github.com/docker/containerd/releases" "grep -e … -e '•[[:space:]]*[0-9]*\.[^[:space:]]*$'"
add_data "runc" "https://github.com/opencontainers/runc/releases" "grep -e '• v' -e … -e '•[[:space:]]*[0-9]*\.[^[:space:]]*$'"
add_data "Slf4j" "http://www.slf4j.org/download.html" "grep '.zip$'"
add_data "Logback" "http://logback.qos.ch/download.html" "grep '.zip$'"
add_data "Log4j" "http://logging.apache.org/log4j/2.x/download.html" "grep 'Apache Log4j 2 binary (zip)'"
add_data "nginx" "http://nginx.org/en/download.html" "grep -w 'pgp'"
add_data "Apache" "http://httpd.apache.org" "grep -w 'Released'"
add_data "Tomcat" "http://tomcat.apache.org" "grep 'Released$'"
add_data "Apr" "https://apr.apache.org" "grep 'Released$'"
add_data "memcached" "https://github.com/memcached/memcached/releases" "grep '…'"
add_data "memcached-session-manager" "https://github.com/magro/memcached-session-manager/releases" "grep '…'"
add_data "session-managers" "https://github.com/pivotalsoftware/session-managers/releases" "grep '^[[:blank:]]*v'"
add_data "spymemcached" "https://github.com/couchbase/spymemcached/releases" "grep '…'"
add_data "kryo-serializers" "https://github.com/magro/kryo-serializers/releases" "grep '…'"
add_data "kryo" "https://github.com/EsotericSoftware/kryo/releases" "grep -e … -e .zip"
add_data "minlog" "https://github.com/EsotericSoftware/minlog/releases" "grep -e … -e .zip"
add_data "reflectasm" "https://github.com/EsotericSoftware/reflectasm/releases" "grep -e … -e .zip"
add_data_mvnrepo "asm" "org.ow2.asm/asm"
add_data "asd" "https://github.com/graysky2/anything-sync-daemon/releases" "grep 'v'"
add_data "psd" "https://github.com/graysky2/profile-sync-daemon/releases" "grep 'v'"
add_data "profile_cleaner" "https://github.com/graysky2/profile-cleaner/releases" "grep 'v'"
add_data "geckodriver" "https://github.com/mozilla/geckodriver/releases" "grep 'v'"
#add_data "smimui7" "https://www.androidfilehost.com/?w=files&flid=18823" " grep 'Folders'|awk '{print \$1}'"
#add_data "smimui7" "https://www.androidfilehost.com/?w=files&flid=18823"
add_data "logstash" "https://www.elastic.co/downloads/logstash" "grep -A1 '^Version'"
add_data "elasticsearch" "https://www.elastic.co/downloads/elasticsearch" "grep -A1 '^Version'"
add_data "kibana" "https://www.elastic.co/downloads/kibana" "grep -A1 '^Version'"
for aa in compiler surefire clean install source jar javadoc antrun site jarsigner dependency;do
	add_data_mvnrepo "maven-$aa-plugin" "org.apache.maven.plugins/maven-$aa-plugin"
done

add_data "redis" "http://redis.io" "grep 'is the latest stable version.'"
#add_data "directory_studio" "http://directory.apache.org/studio/download/download-linux.html" "grep 'tar.gz '|awk -F / '{print \$(NF)}'"
add_data "directory_studio" "http://directory.apache.org/studio/" "grep '^Directory Studio'"
add_data "selenium" "http://www.seleniumhq.org/download/" "grep 'Download version'"
#add_data "forticlient" "https://support.zen.co.uk/kb/Knowledgebase/Fortinet-SSL-VPN-Client" "grep 'linux'"
add_data "forticlient-1" "http://www.traco.hu/tools/" "grep DIR"
add_data "forticlient-2" "https://github.com/dbirks/forticlientsslvpn/tree/master/tarball" "grep forticlientsslvpn"
add_data "Gitblit" "http://gitblit.com/" "grep 'Current Release'"
add_data "Nexus" "https://support.sonatype.com/hc/en-us/categories/202673428-Nexus-Repository-Manager-3" "grep 'Release Notes'"
add_data "redmine_work_time" "https://bitbucket.org/tkusukawa/redmine_work_time/downloads/" "grep '.zip'|awk '{print \$1}'"
add_data "liteide" "https://github.com/visualfc/liteide/releases" "grep 'Ver'"
add_data "vscode" "https://code.visualstudio.com/download" "grep 'Version'"
add_data "vscode1" "https://github.com/Microsoft/vscode/releases" "grep '…'"
add_data "r8152" "http://www.realtek.com.tw/Downloads/downloadsView.aspx?Langid=1&PNid=13&PFid=56&Level=5&Conn=4&DownTypeID=3&GetDown=false" "grep 'LINUX'"

add_mi_rom_data(){ add_data "$1" "$2" "grep '^Author: MIUI Official TeamVersion:'|awk '{print \$5,\$6}'"; }
add_mi_rom_data "mi6-rom" "http://en.miui.com/download-326.html"
add_mi_rom_data "mi8-rom" "http://en.miui.com/download-346.html"
add_mi_rom_data "mimax2-rom" "http://en.miui.com/download-328.html"
add_mi_rom_data "rm4x-rom" "http://en.miui.com/download-321.html"
#add_mi_rom_data "mi2-rom" "http://en.miui.com/download-2.html"

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

