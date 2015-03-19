#!/bin/bash
. /etc/profile.env
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:${ROOTPATH}"

#CPU speed: min 212MHz, max 1700MHZ, current 1700MHz; 67.21% idle
#CPUfreq driver: p4-clockmod
#       powersave       maximise power savings
#       performance     maximise performance
#       dynamic         adjust speed according to CPU load (default)
#       NNN             set CPU to a fixed speed of NNN MHz

bfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq`
pstatus=`speedfreq -s |cut -d" " -f4`
pfreq=`speedfreq -s |cut -d" " -f5`
[ "$pstatus" = fixed ] && pstatus="$bfreq"

#statuslist="dynamic powersave 600 1000 1400 performance"
minfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
maxfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
cpustatlist="dynamic $(echo `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies|tr " " "\n"|sort -u -n`|sed "s/$minfreq/powersave/"|sed "s/$maxfreq/performance/") dynamic"
echo $cpustatlist
cpustatarray=( $cpustatlist )
for seq in `seq 0 $(echo $cpustatlist | wc -w)`
do
	if [ "${cpustatarray[seq]}" = "$pstatus" ]
	then
		newseq=$((seq +1))
		expr ${cpustatarray[newseq]} / 1000 1>/dev/null 2>&1 && newstatus=`expr ${cpustatarray[newseq]} / 1000` || newstatus=${cpustatarray[newseq]}
		break
	fi
done
[ -z "$newstatus" ] && newstatus=dynamic
speedfreq -p $newstatus
#echo Last status: $pstatus
echo "New Status: $newstatus" "("`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`")"
echo Last Freq: $bfreq Hz
echo New Freq:`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq` Hz
