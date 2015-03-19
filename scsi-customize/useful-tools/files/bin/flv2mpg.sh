#!/bin/bash
if [ "$1" == "" ] ; then
	echo "usage: flv2mpg [file.flv]"
elif [ "$1" == "-help" ] ; then
	echo "usage: flv2mpg [file.flv]"
else
	ffmpeg -i "$1" -acodec mp3 -ab 56 -ar 22050 -b 500  -s 320x240 $1.mpg
fi
