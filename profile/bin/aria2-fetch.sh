#!/bin/bash
BINDIR=`dirname $(which $0)`
GENTOO_MIRRORS_FILE="$BINDIR/gentoomirrors";
THIRDPARTY_MIRRORS_FILE="/usr/portage/official/profiles/thirdpartymirrors";
BLACK_LIST_FILE="$BINDIR/blacklistmirrors";

[ -f "$GENTOO_MIRRORS_FILE" ] || { echo GENTOO_MIRRORS_FILE $GENTOO_MIRRORS_FILE not found.; exit 1; }
[ -f "$THIRDPARTY_MIRRORS_FILE" ] || { echo THIRDPARTY_MIRRORS_FILE $THIRDPARTY_MIRRORS_FILE not found.; exit 1; }

# Amount of expected connections per mirror.
SPLITS_FACTOR=5;
# Minimal connections per file.
MIN_SPLITS=5;
# Maximal connections per file.
MAX_SPLITS=15;

#TEST_URL=true
#ARIA2C_SERVER_STAT='/var/portage/tmp/aria2-fetch.stat'

ARIA2C_OPTS="--continue --ftp-pasv 
	--timeout=30
	--connect-timeout=20
	--max-tries=2
	--use-head=false 
       	--file-allocation=none 
	--check-certificate=false" 
	#--server-stat-timeout=2592000
	#--retry-wait=0
	#--max-concurrent-downloads=5
	#--uri-selector=adaptive 
[ -n "$ARIA2C_SERVER_STAT" ] && ARIA2C_OPTS="$ARIA2C_OPTS --server-stat-of=$ARIA2C_SERVER_STAT --server-stat-if=$ARIA2C_SERVER_STAT"

testurl()
{
	[ -z "$1" ] && return 1
	url=`dirname $1`/cccddddeeefff.zpp432
	aria2c --timeout=10 ${ARIA2C_OPTS} --connect-timeout=2 -q --split=10 --dir=/tmp --out=test.aria2c $url
	case $? in
	3) return 0;;
	0) echo $1 may download null file;;
	2) echo $1 timeout;;
	6) echo $1 network problem occurs;;
	7) echo $1 unfinished downloads;;
	*) echo $1 unkonw error;;
	esac
	
	return 1 
}

[ $# -ne 3 ] && { echo 'invalid arguments.'; exit 1; }

DIR=$1
FILE=$2
URI=$3

URIHOST=`echo $URI|cut -d/ -f-3`

MIRRORS="$(cat $GENTOO_MIRRORS_FILE $THIRDPARTY_MIRRORS_FILE|grep $URIHOST)"

#[ -f "$BLACK_LIST_FILE" ] && BLACK_LIST="`cat $BLACK_LIST_FILE`"

echo MIRRORS=\"$MIRRORS\"
echo DIR=\"$DIR\", FILE=\"$FILE\", URI=\"$URI\"

OLDIFS=$IFS
IFS="
"
unset URIS
for mirror in $MIRRORS
do
    basehost=`echo "$mirror"|sed "s/ /\n/g"|grep "$URIHOST"`
    echo "$URI"|grep -q "^$basehost"|| continue

    IFS=$OLDIFS
    mirror_name=`echo $mirror|cut -d" " -f1`
    echo "Mirror: $mirror_name"
    basehost=`echo $basehost|sed "s/\\//\\\\\\\\\\//g"`
    for newhost in `echo $mirror|cut -d" " -f2-`
    do
#	echo "blacklist=$BLACK_LIST"
#	echo "newhost=$newhost"
	if echo "$BLACK_LIST"|grep $newhost
	then
		echo skip $newhost
		continue
	fi
	newhost=`echo $newhost|sed "s/\\//\\\\\\\\\\//g"`
	newuri=`echo $URI|sed "s/$basehost/$newhost/"`
	
	if [ -n "$TEST_URL" ]
	then
		testurl $newuri && URIS="$URIS $newuri" 
	else
		URIS="$URIS $newuri"
	fi
    done
    break
done

if [ -n "$URIS" ]
then
    ARIA2C_OPTS="$ARIA2C_OPTS --lowest-speed-limit=1K"
else
    ARIA2C_OPTS="$ARIA2C_OPTS --lowest-speed-limit=10"
    URIS=$URI
fi

splits=$(expr `echo "$URIS"|wc -w` \* $SPLITS_FACTOR)
#echo URIS="$URIS"
[ $splits -gt $MAX_SPLITS ] && splits=$MAX_SPLITS
[ $splits -lt $MIN_SPLITS ] && splits=$MIN_SPLITS

echo "Servers: `echo "$URIS"|wc -w`"
echo "Splits: $splits"

[ -n "$ARIA2C_SERVER_STAT" ] && rm -f "$ARIA2C_SERVER_STAT"
TEMP_FILE=".aria2-fetch.$FILE"

#eval aria2c ${ARIA2C_OPTS} --split=${splits} --dir=${DIR} --out=${TEMP_FILE} ${URIS}
eval aria2c ${ARIA2C_OPTS} --split=${splits} --dir=${DIR} --out=${FILE} ${URIS}
#eval aria2c ${ARIA2C_OPTS} --split=${splits} --dir=${DIR} ${URIS}
[ $? -ne 0 ] && exit 1
#mv -f "${DIR}/${TEMP_FILE}" "${DIR}/${FILE}"
exit 0

