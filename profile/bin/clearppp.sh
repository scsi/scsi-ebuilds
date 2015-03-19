list=`ifconfig |grep "^ppp"|awk '{print $1}'`
head=`echo "$list"|head -1`
tail=`echo "$list"|tail -1`
#echo $head $tail
for aa in `echo "$list"|grep -v -e $head -e $tail`
do
	echo ifconfig $aa down
	ifconfig $aa down
done
