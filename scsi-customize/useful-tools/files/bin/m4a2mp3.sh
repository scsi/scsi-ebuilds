#!/bin/bash
#
# Convert m4a to mp3

for i in "$@"
do
  mplayer -ao pcm "$i" -ao pcm:file="$i.wav"
  dest=`echo "$i.wav"|sed -e 's/m4a.wav$/mp3/'`
  lame -h -b 192 "$i.wav" "$dest"
  rm $i $i.wav
done
