#!/bin/sh
. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"

hname=$(/bin/uname -n)
#[ "$hname" = "scsioffice" ] && (cd /var/portage/ebuildteam;cvs update) 1>/dev/null 2>&1

layman -S 1>/dev/null 2>&1
nice -n 19 /usr/sbin/esync --nospinner -n 1>/dev/null 2>&1
(echo "----- clean -----"
 nice -n 19 /usr/bin/eclean-dist -C
 nice -n 19 /usr/bin/eclean-pkg -C
 echo "----- ebuild update check -----"
 emerge -uDNptvq --nospinner world
 emerge -uDNfvq --nospinner world 1>/dev/null 2>&1
 echo
 echo "----- glsa check (security) -----"
 glsa-check -ln 2>/dev/null|grep -v "\ \[U\]"
 echo
 echo "----- depclean check -----"
 emerge -pv --nospinner depclean|grep -v "\*\*\*"
 echo  "----- rootkit check -----"
# rkhunter --update 
#rkhunter -c --cronjob --quiet
)|/bin/mail -s "$hname: emerge report" scsichen@gmail.com
