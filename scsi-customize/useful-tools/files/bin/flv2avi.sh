#!/bin/bash
if [ "$1" == "" ] ; then
	echo "usage: flv2avi [file.flv]"
elif [ "$1" == "-help" ] ; then
	echo "usage: flv2avi [file.flv]"
else
	#ffmpeg -i "$1" -ab 56 -ar 22050 -b 500  -s 320x240 $1.mpg
	ffmpeg -i "$1" -vcodec mpeg4 -acodec mp3 ${1/flv/avi}
fi
