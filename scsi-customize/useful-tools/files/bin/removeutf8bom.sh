#/bin/bash
#bom=`printf "efbbbf"|echohex -r`
bom=`echo -e "\0357\0273\0277"`
for xmlfile in $@
do
	if grep -q ^$bom <$xmlfile
	then
		echo $xmlfile: remove bom
		cp $xmlfile ${xmlfile}~
		sed "s/^$bom//" <${xmlfile}~ >$xmlfile
	else
		echo $xmlfile: skip
	fi
done
