#!/bin/bash

GENTOO_MIRRORS_FILE='/usr/local/bin/gentoomirrors';
THIRDPARTY_MIRRORS_FILE='/var/portage/official/profiles/thirdpartymirrors';
BLACK_LIST_FILE='/usr/local/bin/blacklistmirrors';

[ -f "$GENTOO_MIRRORS_FILE" ] || { echo GENTOO_MIRRORS_FILE $GENTOO_MIRRORS_FILE not found.; exit 1; }
[ -f "$THIRDPARTY_MIRRORS_FILE" ] || { echo THIRDPARTY_MIRRORS_FILE $THIRDPARTY_MIRRORS_FILE not found.; exit 1; }

# Amount of expected connections per mirror.
SPLITS_FACTOR=5;
# Minimal connections per file.
MIN_SPLITS=10;
# Maximal connections per file.
MAX_SPLITS=20;

#TEST_URL=true
#ARIA2C_SERVER_STAT='/var/portage/tmp/aria2-fetch.stat'

ARIA2C_OPTS="--continue --ftp-pasv 
	--timeout=2
        --max-tries=1
        --retry-wait=0	       
	--use-head=false 
       	--file-allocation=none 
	--check-certificate=false 
	--server-stat-timeout=2592000"
	#--max-concurrent-downloads=5
	#--uri-selector=adaptive 
[ -n "$ARIA2C_SERVER_STAT" ] && ARIA2C_OPTS="$ARIA2C_OPTS --server-stat-of=$ARIA2C_SERVER_STAT --server-stat-if=$ARIA2C_SERVER_STAT"

testurl()
{
	[ -z "$1" ] && return 1
	url=$1/cccddddeeefff.zpp432
	aria2c ${ARIA2C_OPTS} -q --split=1 --dir=/tmp --out=test.aria2c $url
	case $? in
	3) return 0;;
	0) echo $1 may download null file
		echo $1>>$BLACK_LIST_FILE;;
	2) echo $1 timeout;;
	6) echo $1 network problem occurs;;
	7) echo $1 unfinished downloads;;
	*) echo $1 unkonw error;;
	esac
	
	return 1 
}


all_hosts="$(cat $GENTOO_MIRRORS_FILE $THIRDPARTY_MIRRORS_FILE|cut -d" " -f2-)"

blist=""
for host in $all_hosts
do
	if ! testurl $host
	then
		blist="${blist}${host}
"
	fi
done
echo "$blist" >$BLACK_LIST_FILE
