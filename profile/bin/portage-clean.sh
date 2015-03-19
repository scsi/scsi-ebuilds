#!/bin/bash
export LANG=c

checkunmask()
{
    echo "checking $1 ..."
    while read line; do
        if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
                continue
        fi

        category=`echo $line | cut -d" " -f1 | sed -e 's/^[<>=]*//' -e 's/\/.*//'`
        package=`echo $line | cut -d" " -f1 | sed  -e 's/^[<>=]*[a-z]*\-[a-z]*\///' -e 's/\-[0-9].*$//'`
        installed_version=`eix --format '{installedversions}<installedversions>{else}none{}' -C $category -e $package | head -n 1`
        available_versions=`eix --format '<availableversions>' -C $category -e $package | head -n 1`

        if [[ "$installed_version" == "" ]]; then
                echo "$category/$package: Package does not exist (or a problem occured)"
                continue
        fi

        if [[ "$installed_version" == "none" ]]; then
                echo "$category/$package: Package is not installed"
                continue
        fi

        if [[ $(echo $available_versions | grep -P "$installed_version(\s|\[)") == "" ]]; then
                echo "$category/$package: $installed_version is no longer in portage"
                continue
        fi

        if [[  $(echo $available_versions | grep -P "\[M\]$installed_version(\s|\[)") == "" ]]; then
                echo "$category/$package is no longer masked"
        fi

    done <$1
}

checkkeyword()
{
    echo "checking $1 ..."
    while read line; do
        # skip empty or commented out lines
        if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
            continue
        fi

        # parse the entry from the file
        category=`echo $line | cut -d" " -f1 | sed -e 's/^[~<>=]*//' -e 's/\/.*//'`
        package=`echo $line | cut -d" " -f1 | sed  -e 's/^[~<>=]*[a-z0-9]*\-[a-z0-9]*\///' -e 's/\-[0-9].*$//'`
	version=`echo $line | cut -d" " -f1 | sed -e "s/^[~<>=]*$category\/$package-//"`
	#echo $category/$package $version
        # parse the output of eix
        installed_version=`eix --format '{installedversions}<installedversions>{else}none{}' -C $category -e $package | head -n 1|sed -e 's/[0-9][0-9]:[0-9][0-9]:[0-9][0-9].*//'|cut -d "(" -f1`
        available_versions=`eix --format '<availableversions>' -C $category -e $package | head -n 1|cut -d "{" -f1`
        if [[ "$installed_version" == "" ]]; then
            echo "$category/$package: Package does not exist (or a problem occured)"
            continue
        fi

        if [[ "$installed_version" == "none" ]]; then
            echo "$category/$package: Package is not installed"
            continue
        fi

        if [[ $(echo $available_versions | grep -P "$installed_version(\s|\[)") == "" ]]; then
            echo "$category/$package: $installed_version is no longer in Portage"
        fi

        if [[ $(echo $available_versions | grep -P "\s$installed_version(\s|\[)") != "" ]]; then
            echo "$category/$package[$version] has become stable"
        fi

    done <$1
}

check()
{
    echo "checking $1 ..."
    tmpfile=/tmp/`basename $1`
    >$tmpfile
    while read line; do
        # skip empty or commented out lines
        if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
            continue
        fi
        # parse the entry from the file
        category=`echo $line | cut -d" " -f1 | sed -e 's/^[~<>=]*//' -e 's/\/.*//'`
        package=`echo $line | cut -d" " -f1 | sed  -e 's/^[~<>=]*[a-z0-9]*\-[a-z0-9]*\///' -e 's/\-[0-9].*$//'`
	slot=`echo $package:|cut -d: -f2`
	package=`echo $package|cut -d: -f1`
	[ -n $slot ]&&version=`echo $line | cut -d" " -f1 | sed -e "s/^[~<>=]*$category\/$package//"`|| version=""
	echo $category/$package $version "[$slot]"
	
        # parse the output of eix
	[ -n "$slot" ]&&infos=`equery -N -q -C l  $category/$package|grep "($slot)"`||infos=`equery -N -q -C l $category/$package`
	#echo $infos
	if [ -z "$infos" ]
	then
	    #printf "    *%-40s :not installed.\n" "$category/$package"
	    continue
	fi

	echo $infos
	case "$2" in
	M|m)
		if ! echo "$infos"|grep -q "\[.*M.*\]"
		then
		    printf "    *%-40s :unmusk.\n" "$category/$package"
		    continue
		fi
		;;
	*)
		if ! echo "$infos"|grep -q "\[.*~.*\]"
		then
		    printf "    *%-40s :stable.\n" "$category/$package"
		    continue
		else
		    echo $line >>$tmpfile
		fi
		;;
	esac
    done <$1
    if [ -f $tmpfile ]
    then
	 echo -
	 diff -Nu $1 $tmpfile
	 ret=$?
	 echo -
	 if [ "$ret" -ne 0 ]
	 then
		 printf "\nDo you want update %s [y/N]" "$1"
		 read ans
		 case "$ans" in
		  y|Y)
		  	echo -e "\nUpdate $1"
			sort $tmpfile> $1;;
		  *)
		  	echo "skip update $1"
		 esac
	else
		echo "no need update $1"
	fi
    else
	    echo "can not found $tmpfile"
    fi
}
echo "## Showing useless entries in package.keywords..."
for aa in `find -L /etc/portage/package.keywords/ -type f -name "temp.keywords"|grep -v .svn`
do
    check $aa k
    echo
done

#echo -e "\n## Showing useless entries in package.unmask..."
#for aa in `find -L /etc/portage/package.unmask/ -type f|grep -v .svn`
#do
#    check $aa M
#    echo
#done
