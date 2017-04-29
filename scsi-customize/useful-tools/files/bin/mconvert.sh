#!/bin/bash
##############################################
#  Program Name: mconvert.sh
#  Purpose: ?n???ഫ
#  Author: ???i?w (Chen Yung Chou)
#  Created Date: 2003/09/04
#  Modified:
#  Last Modify Date: 2003/09/23
#  Version:
#  Histtory:
##############################################
convert_mp3tag()
{
	case $1 in
		0) echo "Blues";;
		1) echo "Classic Rock";;
		2) echo "Country";;
		3) echo "Dance";;
		4) echo "Disco";;
		5) echo "Funk";;
		6) echo "Grunge";;
		7) echo "Hip-Hop";;
		8) echo "Jazz";;
		9) echo "Metal";;
		10) echo "New Age";;
		11) echo "Oldies";;
		12) echo "Other";;
		13) echo "Pop";;
		14) echo "R&B";;
		15) echo "Rap";;
		16) echo "Reggae";;
		17) echo "Rock";;
		18) echo "Techno";;
		19) echo "Industrial";;
		20) echo "Alternative";;
		21) echo "Ska";;
		22) echo "Death Metal";;
		23) echo "Pranks";;
		24) echo "Soundtrack";;
		25) echo "Euro-Techno";;
		26) echo "Ambient";;
		27) echo "Trip-Hop";;
		28) echo "Vocal";;
		29) echo "Jazz+Funk";;
		30) echo "Fusion";;
		31) echo "Trance";;
		32) echo "Classical";;
		33) echo "Instrumental";;
		34) echo "Acid";;
		35) echo "House";;
		36) echo "Game";;
		37) echo "Sound Clip";;
		38) echo "Gospel";;
		39) echo "Noise";;
		40) echo "AlternRock";;
		41) echo "Bass";;
		42) echo "Soul";;
		43) echo "Punk";;
		44) echo "Space";;
		45) echo "Meditative";;
		46) echo "Instrumental Pop";;
		47) echo "Instrumental Rock";;
		48) echo "Ethnic";;
		49) echo "Gothic";;
		50) echo "Darkwave";;
		51) echo "Techno-Industrial";;
		52) echo "Electronic";;
		53) echo "Pop-Folk";;
		54) echo "Eurodance";;
		55) echo "Dream";;
		56) echo "Southern Rock";;
		57) echo "Comedy";;
		58) echo "Cult";;
		59) echo "Gangsta";;
		60) echo "Top 40";;
		61) echo "Christian Rap";;
		62) echo "Pop/Funk";;
		63) echo "Jungle";;
		64) echo "Native American";;
		65) echo "Cabaret";;
		66) echo "New Wave";;
		67) echo "Psychadelic";;
		68) echo "Rave";;
		69) echo "Showtunes";;
		70) echo "Trailer";;
		71) echo "Lo-Fi";;
		72) echo "Tribal";;
		73) echo "Acid Punk";;
		74) echo "Acid Jazz";;
		75) echo "Polka";;
		76) echo "Retro";;
		77) echo "Musical";;
		78) echo "Rock & Roll";;
		79) echo "Hard Rock";;
		80) echo "Folk";;
		81) echo "Folk/Rock";;
		82) echo "National Folk";;
		83) echo "Swing";;
		84) echo "Bebob";;
		85) echo "Latin";;
		86) echo "Revival";;
		87) echo "Celtic";;
		88) echo "Bluegrass";;
		89) echo "Avantgarde";;
		90) echo "Gothic Rock";;
		91) echo "Progressive Rock";;
		92) echo "Psychedelic Rock";;
		93) echo "Symphonic Rock";;
		94) echo "Slow Rock";;
		95) echo "Big Band";;
		96) echo "Chorus";;
		97) echo "Easy Listening";;
		98) echo "Acoustic";;
		99) echo "Humour";;
		100) echo "Speech";;
		101) echo "Chanson";;
		102) echo "Opera";;
		103) echo "Chamber Music";;
		104) echo "Sonata";;
		105) echo "Symphony";;
		106) echo "Booty Bass";;
		107) echo "Primus";;
		108) echo "Porn Groove";;
		109) echo "Satire";;
		110) echo "Slow Jam";;
		111) echo "Club";;
		112) echo "Tango";;
		113) echo "Samba";;
		114) echo "Folklore";;
		*) echo "";;
	esac
}

get_ogg_title="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^title\=         | sed s/^[^\=]*\=//"
get_ogg_artist="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^artist\=        | sed s/^[^\=]*\=//"
get_ogg_album="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^album\=         | sed s/^[^\=]*\=//"
get_ogg_date="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^date\=          | sed s/^[^\=]*\=//"
get_ogg_comment="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^comment\=       | sed s/^[^\=]*\=//"
get_ogg_trcknr="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^tracknumber\=   | sed s/^[^\=]*\=//"
get_ogg_genre="/usr/bin/ogginfo \"\$ifilename\" | grep -i ^genre\=         | sed s/^[^\=]*\=//"

get_mp3_title="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TIT2 | sed s/^[^:]*:\ //"
get_mp3_artist="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TPE1 | sed s/^[^:]*:\ //"
get_mp3_album="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TALB | sed s/^[^:]*:\ //"
get_mp3_date="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TYER | sed s/^[^:]*:\ //"
get_mp3_comment="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ COMM | sed s/^[^:]*:\ // | sed s/^\(.*\)\"\[.*\]\":\ //"
get_mp3_trcknr="/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TRCK | sed s/^[^:]*:\ //"
get_mp3_genre="convert_mp3tag \`/usr/bin/id3info \"\$ifilename\" | grep ^\=\=\=\ TCON | sed s/^[^:]*:\ // | sed s/^\(// | sed s/\)$//\`"

wav_to_mp3()
{
	ifilename=$1
	ofilename=$2
	#nice /usr/bin/lame -h -m s -b 160 --tn "$trcknr" --tt "$title" --tl "$album" --ta "$artist" "$ifilename" "$ofilename"
	#nice /usr/bin/lame -h -m s -b 128 --resample 44.1 --scale 5  --tt "$title" --ta "$artist" --tl "$album" --ty "$date" --tc "$comment" --tn "$trcknr" --tg "$genre" "$ifilename" "$ofilename"
	nice /usr/bin/lame -h -m s -b 320 --scale 5  --tt "$title" --ta "$artist" --tl "$album" --ty "$date" --tc "$comment" --tn "$trcknr" --tg "$genre" "$ifilename" "$ofilename"
	#nice /usr/bin/lame -h -m s -b 128 --resample 44.1 --tt "$title" --ta "$artist" --tl "$album" --ty "$date" --tc "$comment" --tn "$trcknr" --tg "$genre" "$ifilename" "$ofilename"
	return $?
}

mp3_to_wav()
{
	ifilename=$1
	ofilename=$2
	nice /usr/bin/mpg321 -v --stereo  -w "$ofilename" "$ifilename"
	return $?
}

ogg_to_wav()
{
	ifilename=$1
	ofilename=$2
	#/usr/bin/ogg123 -d wav -f "$ofilename" "$ifilename"
	/usr/bin/oggdec -o "$ofilename" "$ifilename"
	return $?
}

wav_to_ogg()
{
	ifilename=$1
	ofilename=$2
	#nice /usr/bin/oggenc -r -q 5 --output="$ofilename" --tracknum "$trcknr" --title "$title" --album "$album" --artist "$artist" "$ifilename"
	nice /usr/bin/oggenc -r -q 5 --output="$ofilename" --artist "$artist" --genre "$genre" --date "$date" --tracknum "$tracknr" --title "$title" --album "album" --comment "$comment" "$ifilename"
	return $?
}

wav_to_flac()
{
	ifilename=$1
	ofilename=$2
	nice /usr/bin/flac -8 -o "$ofilename" "$ifilename"
	return $?
}
flac_to_wav()
{
	ifilename=$1
	ofilename=$2
	nice /usr/bin/flac -d -o "$ofilename" "$ifilename"
	return $?
}
mid_to_wav()
{
	ifilename=$1
	ofilename=$2
	nice /usr/bin/timidity -a -Ew -Ep -Ev -Es -Et -Eo -idq -Owsl "$ifilename" -o "$ofilename"
	return $?
}
wma_to_wav()
{
	#http://www.wer-weiss-was.de/theme12/article1590806.htm
	#mplayer "$1" -ao pcm -vc null -vo null
	#lame --r3mix audiodump.wav "`basename "$1" .wma`.mp3"
	#rm audiodump.wav
	ifilename=$1
	ofilename=$2
	mplayer "$ifilename" -ao pcm  -vc null -vo null -ao pcm:file="$ofilename"
	return $?
}
amr_to_wav()
{
	ifilename=$1
	ofilename=$2
	mplayer "$ifilename" -ao pcm  -vc null -vo null -ao pcm:file="$ofilename"
	return $?
}
ram_to_wav()
{
	wma_to_wav $1 $2
	return $?
}
rm_to_wav()
{
        wma_to_wav $1 $2
        return $?
}

cd_to_wav()
{
	ifilename=$1
	ofilename=$2
	nice /usr/bin/cdda2wav -s -x -H -i1 -B -O wav -D "$cdrom" -t "$ifilename"+"$ifilename" "$ofilename"
	return $?
}

dvd_to_wav()
{
	#http://www.perturb.org/content/dvd2mp3-2.html
	#mkfifo soundpipe
	#lame -b 64 soundpipe audio.mp3 & mplayer -quiet -ao pcm -aofile soundpipe -vo null -vc dummy -aid XXX dvd://
	#Other examples:
	#Create a 64kbs OGG
	#oggenc -b 64 soundpipe -o audio.ogg & mplayer -quiet -ao pcm -aofile soundpipe -vo null -vc dummy -aid 128 dvd://
	#Create a 128kbs MP3
	#lame -b 128 soundpipe audio.mp3 & mplayer -quiet -ao pcm -aofile soundpipe -vo null -vc dummy -aid 128 dvd://
	#Create a 128kbs MP3 of DVD Title 2
	#lame -b 128 soundpipe audio.mp3 & mplayer -quiet -ao pcm -aofile soundpipe -vo null -vc dummy -aid 128 dvd://2
	#Create a 64kbs OGG of DVD Chapters 1-5
	#oggenc -b 64 soundpipe -o audio.ogg & mplayer -quiet -ao pcm -aofile soundpipe -vo null -vc dummy -aid 128 -chaper 1-5 dvd://

	dtitle="`echo $1|cut -d'-' -f1`"
	dchapter="`echo $1|cut -d'-' -f2`"
	echo "title=$dtitle"
	echo "chapter=$dchapter"
	#if [ -z "$chapter" ]
	if [ -z "$dchapter" ]
	then
		dchapter="$dtitle"
		dtitle=""
	fi
	echo "title=$dtitle"
	echo "chapter=$dchapter"
	ofilename=$2

	#mplayer -ao pcm -aofile "$ofilename" -vo null -vc dummy -aid 128 -cdrom-device $cdrom -dvd-device $cdrom -chapter $dchapter-$dchapter dvd://$dtitle
	mplayer -ao pcm -ao pcm:file="$ofilename" -vo null -vc dummy -cdrom-device $cdrom -dvd-device $cdrom -chapter $dchapter-$dchapter dvd://$dtitle
	#mencoder  -oac pcm -ovc copy -cdrom-device $cdrom -dvd-device $cdrom -chapter $dchapter-$dchapter dvd://$dtitle
	return $?
}

mpeg_to_wav()
{
        ifilename=$1
        ofilename=$2

	mplayer -ao pcm -ao pcm:file="$ofilename" -vo null -vc dummy $ifilename
	return $?
}

cdrom="/dev/cdrom"
execname=`basename $0`
fromcode=`echo $execname|cut -d'2' -f1`
tocode=`echo $execname|cut -d'2' -f2`
if [ "$fromecode" = "$tocode" ]
then
	echo " fromcode must different to tocode."
	exit 1
fi
case $fromcode in
	#"wav"|"mp3"|"ogg"|"wma"|"flac"|"dvd"|"wma"|"mid")
	wav|mp3|ogg|flac|dvd|wma|cd|rm|ram|mid|mpeg|amr)
	;;
	*)
		echo "fromcod must be wav|mp3|ogg|flac|dvd|wma|cd."
		exit 1
	;;
esac

case $tocode in
	wav|mp3|ogg|flac)
	:
	;;
	*)
		echo "tocode must be wav|mp3|ogg|wma|flac."
		exit 1
	;;
esac
echo &
fifofilename="/tmp/cvt.$!.wav"
#cho "make fifo $fifofilename"
mkfifo $fifofilename
trap "rm -f $fifofilename;kill processid 2>/dev/null;exit 2" 0 1 2 9 15
while [ "$1" ]
do
	ifilename="$1"
	ofilename=`basename "$ifilename" .$fromcode`.$tocode
	case $fromcode in
		wma|wav|mp3|ogg|flac)
			if [ ! "`basename "$ifilename" .$fromcode`.$fromcode" = "$ifilename" ]
			then
				echo "----------------------"
				echo "skip $ifilename, because file name not end by \".$fromcode\"."
				echo "----------------------"
				shift
				continue
			fi
			if [ ! -f "$ifilename" ]
			then
				echo "----------------------"
				echo "skip $ifilename, because file name is not exist."
				echo "----------------------"
				shift
				continue
			fi
		;;
	esac

	if [ -f "$ofilename" -o -d "$ofilename" ]
	then
		echo "----------------------"
		echo "skip $ifilename, because $ofilename is exist."
		echo "----------------------"
		shift
		continue
	fi

	echo "----------------------"
	echo "converting $ifilename > $ofilename"
	echo "--------"
	case "$fromcode" in
	mp3)
		title="`eval $get_mp3_title`"
		artist="`eval $get_mp3_artist`"
		album="`eval $get_mp3_album`"
		date="`eval $get_mp3_date`"
		comment="`eval $get_mp3_comment`"
		trcknr="`eval $get_mp3_trcknr`"
		genre="`eval $get_mp3_genre`"
		;;
	ogg)
		title="`eval $get_ogg_title`"
		artist="`eval $get_ogg_artist`"
		album="`eval $get_ogg_album`"
		date="`eval $get_ogg_date`"
		comment="`eval $get_ogg_comment`"
		trcknr="`eval $get_ogg_trcknr`"
		genre="`eval $get_ogg_genre`"
		;;
	cd)
		title="`eval $get_ogg_title`"
		artist="`eval $get_ogg_artist`"
		album="`eval $get_ogg_album`"
		date="`eval $get_ogg_date`"
		comment="`eval $get_ogg_comment`"
		trcknr="`eval $get_ogg_trcknr`"
		genre="`eval $get_ogg_genre`"
		;;
	esac

	songname=`basename "$ifilename" .$fromcode`
	if [ $title ]
	then
		tk=`echo $songname|cut -d'_' -f1`
		tk=`expr ${tk} + 0`
		if [ $? -eq 0 ]
		then
			title=`echo $songname|cut -d'_' -f2`
		else
			title=`echo $songname|cut -d'_' -f1`
			trcknr="";
		fi
	fi

	if [ "$tocode" = "wav" -o  "$fromcode" = "wav" ]
	then
		${fromcode}_to_${tocode} "$ifilename" "$ofilename"
	else
		${fromcode}_to_wav "$ifilename" "$fifofilename" &>/dev/null &
		processid=$!
		wav_to_${tocode} "$fifofilename" "$ofilename"
		#${fromcode}_to_wav "$ifilename" - 2>/dev/null| wav_to_${tocode} - "$ofilename"
	fi
	shift
	echo "--------"
	echo "done"
	echo "----------------------"
done
