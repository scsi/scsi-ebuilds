#!/bin/bash

OVERLAYDIR=/var/portage/ebuildteam
OFFICALDIR=/var/portage/official

TMPFILE=tmpfile
cd $OVERLAYDIR

for overlay_file in `find . -name \*.ebuild`
do
	offical_file=$OFFICALDIR/$overlay_file
	#[ -f $offical_file ] || { echo $overlay_file : no offical; continue; }
	[ -f $offical_file ] ||  continue
	overlay_keywords=`grep KEYWORDS $overlay_file`
	offical_keywords=`grep KEYWORDS $offical_file`
	if [ "$overlay_keywords" = "$offical_keywords" ]
	then
		:
		#echo $overlay_file: match
	else
		echo
		echo
		echo =====================================
		echo $overlay_file
		echo OVERLAY:$overlay_keywords
		echo OFFICAL:$offical_keywords
		printf "Modify it ?(y/N) "
		read answer
		if [ "$answer" = y -o "$answer" = Y -o "$answer" = yes -o "$answer" = YES ]
		then
			sed -e "s/$overlay_keywords/$offical_keywords/" $overlay_file >$TMPFILE
			mv $TMPFILE $overlay_file
			echo ==
			svn diff $overlay_file
			echo ==
			printf "Modification right ?(y/N) "
			read answer
			if [ "$answer" = y -o "$answer" = Y -o "$answer" = yes -o "$answer" = YES ]
			then
				ebuild $overlay_file digest
			 	svn commit -m "modify KEYWORDS to offical"  `dirname $overlay_file`
			fi
		fi
	fi
done
