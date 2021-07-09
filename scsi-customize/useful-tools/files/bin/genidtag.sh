#!/bin/bash
die(){ echo "$*"; exit 1; }
[[ -d $1 ]] || die "dir '$1' not exit"
dname=`basename $1`

#album_name
#album_name-2011
#album_name-artis_name
#album_name-artis_name-2011
#01.album_name
#01.album_name-2011
#01.album_name-artis_name
#01.album_name-artis_name-2011
[[ $dname =~ ^([0-9]+\.)?([^-]+)(-([^0-9][^-]+))?(-([0-9]{4}))?$ ]] || die "dir name '$dname' format not supported."
album="${BASH_REMATCH[2]//_/ }"
dyear="${BASH_REMATCH[6]}"
dartist="${BASH_REMATCH[4]//_/ }"
[[ $2 ]] && dartist="${2//_/ }"
[[ $dartist ]] || dartist="$album"
#declare -p dartist album dyear
total=`ls $1/*.mp3|wc -l`
for mp3file in $1/*.mp3
do 
    name=`basename "$mp3file" .mp3`
    #song_name
    #song_name-2011
    #song_name-artis_name
    #song_name-artis_name-2011
    #01.song_name
    #01.song_name-2011
    #01.song_name-artis_name
    #01.song_name-artis_name-2011
    #001.01.song_name
    #001.01.song_name-2011
    #001.01.song_name-artis_name
    #001.01.song_name-artis_name-2011
    name=${name//_/ }
    [[ $name =~ ^(([0-9]+)\.)?(([0-9]+)\.)?([^-]+)(-([^0-9][^-]+))?(-([0-9]{4}))?$ ]] || die "file name '$name' format not supported."
    song=${BASH_REMATCH[5]}
    track=${BASH_REMATCH[4]:-${BASH_REMATCH[2]}}
    artist=${BASH_REMATCH[7]:-$dartist}
    year=${BASH_REMATCH[9]:-$dyear}
    set -x
    #id3tag -2 --total=$total --song="$song" --artist="$artist" --track="$track" --year="$year" --album="$album" "$mp3file"
    id3tag --total=$total --song="$song" --artist="$artist" --track="$track" --year="$year" --album="$album" "$mp3file"
	mid3iconv --remove-v1 "$mp3file"
    #id3v2 -2 --total=$total --song="$song" --artist="$artist" --track="$track" --year="$year" --album="$album" "$mp3file"
	#mid3iconv -e utf-8 --remove-v1 "$mp3file"
    set +x
done

#mp3gain --auto *.mp3

#printf "gain mp3? " ; read ans
#echo $ans|grep -e "^\(y\|Y\|Yes\|yes\|YES\)$" 1>/dev/null 2>/dev/null && mp3gain --auto *.mp3
