WORKDIR=/var/portage/portage-snapshots
cd $WORKDIR || { echo $WORKDIR not exist.; exit 1; }

VERSION_FILE=verson.txt
OLD_VERSION=`cat $VERSION_FILE`
SERVER="http://distfiles.gentoo.org/snapshots"
#SERVER="http://gentoo.cs.nctu.edu.tw/gentoo/snapshots"
#SERVER="ftp://rsync6.tw.gentoo.org/Linux/Gentoo/snapshots"
#SERVER="ftp://rsync2.tw.gentoo.org/Linux/Gentoo/snapshots"
#SERVER="ftp://ftp.isu.edu.tw/Linux/Gentoo/snapshots"
#NEW_VERSION=`wget --no-cache -q -O - $SERVER |sed 's/width/widta/'|w3m -O big5 -dump -T  text/html -cols 1000|grep " portage-latest.tar.bz2 "|cut -d- -f4|cut -d. -f1`

#date -d yesterday +%Y%m%d

NEW_VERSION=`wget --no-cache -q -O - $SERVER |sed 's/width/widta/'|w3m -O big5 -dump -T  text/html -cols 1000|grep " portage-.*\.tar.bz2 "|awk '{print $3}'|grep -v latest|sort|tail -1`
#NEW_VERSION=`wget --no-cache -q -O - $SERVER |sed 's/width/widta/'|w3m -O big5 -dump -T  text/html -cols 1000|grep "portage-.*\.tar.bz2 "|awk '{print $1}'|grep -v latest|sort|tail -1`
if [ -z "$NEW_VERSION" ]
then
	echo "cat not get remote verson"
	exit 1
fi
echo "Old Version: $OLD_VERSION"
echo "New Version: $NEW_VERSION"

if [ "$OLD_VERSION" = "$NEW_VERSION" ]
then
	echo "no need update"
	exit 0
fi

echo "get $NEW_VERSION"

rm -rf portage-*.tar.bz2
if wget $SERVER/$NEW_VERSION
then
	echo "remove old portage..."
	rm -rf portage
	echo "uncompress protage..."
	tar -xjf $NEW_VERSION
	echo "done"
	echo $NEW_VERSION >$VERSION_FILE
else
	echo "wet $NEW_VERSION error!"
fi
