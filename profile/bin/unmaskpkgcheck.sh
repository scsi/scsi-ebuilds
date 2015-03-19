#!/bin/bash
	
paserit()
{
	status=$1
	case "$status" in
	keywords)
		file=/etc/portage/package.keywords
		tag_pattern="~"
		tagmsg="has become stable"
		echo "## Showing useless entries in package.keywords..."
	;;
	unmask)
		file=/etc/portage/package.unmask
		tag_pattern="M"
		tagmsg="is no longer masked"
		echo "## Showing useless entries in package.unmask..."
	;;
	*)
		echo "parameter error."
		return 1
	;;
	esac
	
	while read line; do
		# skip empty or commented out lines
		if [[ $(echo $line | grep ^[^\#$]) == "" ]]; then
			continue
		fi
		
		# parse the entry from the file
		category=`echo $line | cut -d" " -f1 | sed -e 's/^[<>=~]*//' -e 's/\/.*//'`
		package=`echo $line | cut -d" " -f1 | sed  -e 's/^[<>=~]*[a-z][a-z0-9]*\-[a-z][a-z0-9]*\///' -e 's/\-[0-9].*$//'|cut -d: -f1`
		slot=`echo $line | cut -d" " -f1 | sed  -e 's/^[<>=\~]*[a-z][a-z0-9]*\-[a-z][a-z0-9]*\///' -e 's/\-[0-9].*$//'|cut -d: -f2`
		
		# parse the output of eix
	#installed_version=`eix --format '{installedversions}<installedversions>{else}none{}' -C $category -e $package | head -n 1`
		installed_version=`eix --format '<fullinstalled>' -C $category -e $package|cut -d" " -f1|cut -d"[" -f1|cut -d"!" -f1|cut -d"	"  -f1`
		available_versions=`eix --format '<fullavailable>' -C $category -e $package|cut -d" " -f1|cut -d"[" -f1|cut -d"!" -f1|cut -d"	"  -f1`
		msg=""
		
	#	echo line=$line
	#	echo category=$category
	#	echo package=$package
	#	echo slot=$slot
	#	echo installed_version=$installed_version
	#	echo available_versions=$available_versions
		
		if [[ "$installed_version" == "" ]]; then
		#echo "$category/$package: Package does not exist (or a problem occured)"
			msg="does not exist (or a problem occured)"
		elif [[ "$installed_version" == "No" ]]; then
		#echo "$category/$package: Package is not installed"
			msg="is not installed"
		else
			for inspkg in $installed_version
			do
				for avlpkg in $available_versions
				do
					if [ -n "$slot" ]
					then
						echo $avlpkg|grep "($slot)$" >/dev/null 2>&1||continue
					fi
					inspkg_regex=$(echo $inspkg|sed 's/\./\\\./g'|sed 's/\//\\\//g')
					if echo $avlpkg|grep $inspkg_regex >/dev/null 2>&1
					then
						tag=`echo $avlpkg|sed "s/$inspkg_regex//"`
						
						if ! echo $tag|grep "$tag_pattern" >/dev/null 2>&1
						then
							msg="$tagmsg"
							break;
						fi
					fi
					[ -n "$msg" ] && break
				done
			done		
		fi
		[ -n "$msg" ] && printf  "%-50s: %s\n" $line "$msg"
	#	echo  "======================================"
	done < $file
}

paserit keywords
echo "================================================"
paserit unmask