#!/bin/bash
# http://www.it165.net/os/html/201211/3772.html
# https://read01.com/7RDGzR.html
# MX100  72TB
# MX200  80TB
# MX300 160TB

SMART_CONTENT=`smartctl -x $1`

Logical_Sectors_Written=`echo "$SMART_CONTENT"|grep "Logical Sectors Written"|awk '{print $4}'`
#echo "$Logical_Sectors_Written"
write_data=$((Logical_Sectors_Written*100*512/1024/1024/1024))

echo ${write_data:0:(-2)}.${write_data:(-2)}G
Percentage_Used_Endurance_Indicator=`echo "$SMART_CONTENT"|grep "Percentage Used Endurance Indicator"|awk '{print $4}'`
Pstat=`echo "$SMART_CONTENT"|grep "Percentage Used Endurance Indicator"|awk '{print $5}'|cut -c1`
echo ${Percentage_Used_Endurance_Indicator}% $Pstat

Power_On_Hours=`echo "$SMART_CONTENT"|grep "Power_On_Hours"|awk '{print $8}'`
echo "$((Power_On_Hours/24))D$((Power_On_Hours%24))H"
