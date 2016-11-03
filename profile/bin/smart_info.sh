#!/bin/bash
# http://www.it165.net/os/html/201211/3772.html
# https://read01.com/7RDGzR.html
# MX100  72TB IOPS:R85K|W70K THROUPUT:R550MB|W330MB
# MX200  80TB IOPS:R100K|W87K THROUPUT:R555MB|W500MB
# MX300 160TB IOPS:R92K|W83K THROUPUT:R530MB|W510MB

STORAGE_DIR=/var/lib/smart-info
[ -d $STORAGE_DIR ] || mkdir $STORAGE_DIR

[[ $1 =~ ^/ ]] || { echo "device path must start with /."; exit 1; }
[ -b $1 ] || { echo "device $1 is not supported."; exit 1; }
HFILE="$STORAGE_DIR/${1//\//_}"
SMART_CONTENT=`smartctl -x $1` 

Logical_Sectors_Written=`echo "$SMART_CONTENT"|grep "Logical Sectors Written"|awk '{print $4}'`
#echo "$Logical_Sectors_Written"
wg=`echo "scale=2;$Logical_Sectors_Written*512.0/1024/1024/1024"|bc`

#echo ${write_data:0:(-2)}.${write_data:(-2)}G
Percentage_Used_Endurance_Indicator=`echo "$SMART_CONTENT"|grep "Percentage Used Endurance Indicator"|awk '{print $4}'`
Pstat=`echo "$SMART_CONTENT"|grep "Percentage Used Endurance Indicator"|awk '{print $5}'|cut -c1`
#echo ${Percentage_Used_Endurance_Indicator}% $Pstat

Power_On_Hours=`echo "$SMART_CONTENT"|grep "Power_On_Hours"|awk '{print $8}'`
#echo "$((Power_On_Hours/24))D$((Power_On_Hours%24))H"
[ -f $HFILE ] || touch $HFILE
LASTG=`tail -1 $HFILE|awk '{print $5}'|sed "s/[,G]//g"`
ADDG=`echo "scale=2;$wg - ${LASTG:-0}"|bc`
printf "%s %d%% %s %s %'0.2fG +%'0.2fG\n" `date "+%Y-%m-%d_%H:%M:%S.%3N"` "${Percentage_Used_Endurance_Indicator}" "$Pstat" $((Power_On_Hours/24))D$((Power_On_Hours%24))H $wg ${ADDG}|tee -a $HFILE
