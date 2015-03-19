#!/bin/sh
#set -x
getnewversion()
{
	[ $# -ne 2 ] && return 1
	for n in `seq 1 3`
	do
		v1=`echo $1|cut -d. -f$n`
		v2=`echo $2|cut -d. -f$n`
		[ -z "$v1" ] && { echo $2; return 0;}
		[ -z "$v1" ] && { echo $1; return 0;}
		[ $v1 -gt $v2 ] && { echo $1; return 0;}
		[ $v1 -lt $v2 ] && { echo $2; return 0;}
	done
	{ echo $1; return 0;}
}
content=`wget -O - http://www.csie.nctu.edu.tw/~cp76/gcin/download/ 2>/dev/null`
#content=`cat gcin.txt`
[ $? -ne 0 ] && { echo can not connect.; exit 1 ; }

#ebuild=`echo "$content"| w3m -O big5 -dump -T  text/html -cols 50|grep '\['|cut -d']' -f 2|awk '{print $1}'|grep tar|tail -n 1|sed 's/tar\.bz2/ebuild/'`
version=0.0.0
for ver in `echo "$content"| w3m -O big5 -dump -T  text/html -cols 50|grep '\['|cut -d']' -f 2|grep tar|awk '{print $1}'|sed 's/\.tar\.bz2//'|sed 's/gcin-//'`
do
	version=`getnewversion $version $ver`
done
ebuild=gcin-${version}*.ebuild
[ -f /var/portage/ebuildteam/app-i18n/gcin/$ebuild ]&&echo $ebuild is newest.|| \
{
	echo $ebuild is not exists, update it.
	echo "gcin has upate to ${version}. Please update ebuild in GOT."| /bin/mail -s "scsinb: gcin has update to $version!!" scsi@seed.net.tw
}
