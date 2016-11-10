#!/bin/sh
#set -x
version=`w3m http://pcmanx.csie.net/|grep Latest|cut -d- -f3`
ebuild=pcmanx-${version}*.ebuild
[ -f /root/portage/ebuildteam/net-misc/pcmanx/$ebuild ]&&echo $ebuild is newest.|| \
{
	echo $ebuild is not exists, update it.
	echo "pcmanx has upate to ${version}. Please update ebuild in GOT."| /bin/mail -s "scsinb: pcmanx has update to $version!!" scsi@seed.net.tw
}
