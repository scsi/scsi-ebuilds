#!/bin/bash
#
# Convert mp3 to m4a

for i in "$@"
do
  mplayer -ao pcm "$i" -ao pcm:file="$i.wav"
  dest=`echo "$i.wav"|sed -e 's/mp3.wav$/m4a/'`
  faac -b 192 -o "$dest" "$i.wav"
  rm "$i" "$i.wav"
done 
