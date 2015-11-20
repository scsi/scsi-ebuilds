#!/bin/sh

. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"
#MAILADDR="scsichen@gmail.com"
FMAILADDR="risdevp@gmail.com"
TMAILADDR="scsichen@gmail.com"
#MAILTEST=test

getsnapshots()
{
	TIMEOUT=30s
	RETRY=1
	#SNAPSHOTS_URL="ftp://rsync2.tw.gentoo.org/Linux/Gentoo/snapshots"
	#SNAPSHOTS_FILE="`w3m -O big5 -dump -T  text/html -cols 1000 $SNAPSHOTS_URL/|grep " portage-latest.tar.bz2 "|awk '{print $13}'`"
	
	#SNAPSHOTS_URL="http://distro.ibiblio.org/pub/linux/distributions/gentoo/snapshots"
	SNAPSHOTS_URL="ftp://rsync6.tw.gentoo.org/Linux/Gentoo/snapshots"
	SNAPSHOTS_FILE="portage-latest.tar.bz2"
	SNAPSHOTS_CHECKSUM="${SNAPSHOTS_FILE}.md5sum"
	SNAPSHOTS_CHECKSUM_OLD="md5sum.old"
	SNAPSHOTS_DIR="/usr/portage/portage-snapshots"

	while [ -n "$SNAPSHOTS_FILE" -a -z "$MAILTEST" ]
	do
		cd $SNAPSHOTS_DIR
		rm -rf $SNAPSHOTS_CHECKSUM >/dev/null 2>&1
		wget --no-cache --timeout="$TIMEOUT" -t "$RETRY" -q $SNAPSHOTS_URL/$SNAPSHOTS_CHECKSUM || { echo download $SNAPSHOTS_URL/$SNAPSHOTS_CHECKSUM fail; break ; }

		[ `ls -s $SNAPSHOTS_CHECKSUM|awk '{print $1}'` -eq 0 ] && { echo $SNAPSHOTS_CHECKSUM size zero; return ; }

		[ -f $SNAPSHOTS_CHECKSUM_OLD -a "`md5sum $SNAPSHOTS_CHECKSUM_OLD 2>/dev/null|awk '{print $1}'`" = "`md5sum $SNAPSHOTS_CHECKSUM 2>/dev/null|awk '{print $1}'`" ] && {  break ; }

		rm -rf $SNAPSHOTS_FILE >/dev/null 2>&1
		wget --no-cache --timeout="$TIMEOUT" -t "$RETRY" -q $SNAPSHOTS_URL/$SNAPSHOTS_FILE || { echo download $SNAPSHOTS_URL/$SNAPSHOTS_FILE fail; break ; }
	
		md5sum -c $SNAPSHOTS_CHECKSUM >/dev/null 2>&1 || { echo $SNAPSHOTS_FILE checksun not valid; break ; }
	
		rm -rf portage >/dev/null 2>&1
	
		tar -jxf $SNAPSHOTS_FILE || { echo unpack $SNAPSHOTS_FILE fail; break ; } 
	
		rm -rf portage-current >/dev/null 2>&1
		mv portage portage-current
		mv -f $SNAPSHOTS_CHECKSUM $SNAPSHOTS_CHECKSUM_OLD
		rm -rf $SNAPSHOTS_FILE >/dev/null 2>&1
		break
	done

	rm -rf $SNAPSHOTS_FILE $SNAPSHOTS_CHECKSUM>/dev/null 2>&1
}

hname=$(/bin/uname -n)
#[ -z "$MAILTEST" ] && /root/bin/genportage.sh 1>/dev/null 2>&1
[ -z "$MAILTEST" ] && { 
layman -S 1>/dev/null 2>&1
( cd /usr/portage/scsi-ebuilds; git pull ) 1>/dev/null 2>&1
( cd /usr/portage/gentoo-zh; git pull ) 1>/dev/null 2>&1
makewhatis -u 1>/dev/null 2>&1
killall -9 emerge
nice -n 19 eix-sync 1>/dev/null 2>&1
#[ -z "$MAILTEST" ] && nice -n 19 /usr/sbin/emerge-webrsync 1>/dev/null 2>&1
#nice -n 19 eix-update -q 1>/dev/null 2>&1
}

(echo "Subject: $hname: emerge report"
 echo "From: $FMAILADDR"
 echo "To: $TMAILADDR"
 echo "----- clean -----"
# [ -z "$MAILTEST" ] && nice -n 19 eclean-dist -C -q -d -f
 [ -z "$MAILTEST" ] && nice -n 19 eclean-dist -C -d -f >/dev/null
# [ -z "$MAILTEST" ] && nice -n 19 eclean-pkg -C
 echo
 echo "----- ebuild update check -----"
 [ -z "$MAILTEST" ] && emerge -uDNpvq --nospinner world
 [ -z "$MAILTEST" ] && emerge -uDNfvq --nospinner world 1>/dev/null 2>&1
 echo
 echo "----- glsa check (security) -----"
 [ -z "$MAILTEST" ] && glsa-check -ln 2>/dev/null|grep -v "\ \[U\]"
 echo
 echo "----- depclean check -----"
 [ -z "$MAILTEST" ] && emerge -p --nospinner --depclean|grep -v "\*\*\*"
 echo
 #echo "----- revdep-clean check -----"
 #[ -z "$MAILTEST" ] && revdep-rebuild --ignore --nocolor --pretend|grep -v -e ".revdep-rebuild" -e ".done.$"
 #echo
 #echo  "----- rootkit check -----"
 #rkhunter --update 
 #[ -z "$MAILTEST" ] && rkhunter --checkall --cronjob --check-listen --report-mode && rkhunter --update
) |/usr/lib/sendmail -t
