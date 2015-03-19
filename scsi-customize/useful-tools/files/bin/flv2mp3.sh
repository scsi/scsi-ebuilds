#!/bin/bash
if [ "$1" == "" ] ; then
	echo "usage: flv2mp3 [file.flv]"
elif [ "$1" == "-help" ] ; then
	echo "usage: flv2mp3 [file.flv]"
else
	#ffmpeg -i "$1" ${1/flv/mp3}
	ffmpeg -i "$1" -ac 2 -ar 44100 -ab 320 ${1/flv/mp3}
	#ffmpeg -i "$1" -f mp3 -ab 128k -ar 44100 -ac 2 ${1/flv/mp3}
	#mplayer -dumpaudio "$1"-dumpfile ${1/flv/mp3}
fi
