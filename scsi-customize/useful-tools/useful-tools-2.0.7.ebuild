# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A set of useful tools made by scsi"
HOMEPAGE="http://scsichen.blogspot.com"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RDEPEND=""
RDEPEND="media-sound/lame
			media-sound/mpg321
			media-sound/vorbis-tools
			media-libs/flac
			media-video/mplayer
			app-cdr/cdrtools
			media-sound/timidity++
			media-libs/id3lib
			media-libs/mutagen"

src_unpack(){
	mkdir "${S}"
	cd "${S}"
	cp "${FILESDIR}"/{sargs.c,dumphex.c,stripc.c,usleep.c,sdaemon.c,echohex.c} .
}
src_compile(){
	make dumphex
	make stripc
	make usleep
	make sdaemon
	make echohex
}
src_install(){
	exeinto /usr/bin/scsi-useful
	doexe ${FILESDIR}/bin/*
	exeinto /usr/bin
	doexe ${S}/dumphex ${S}/stripc ${S}/usleep ${S}/sdaemon ${S}/echohex
	insinto /etc/env.d/
	doins "${FILESDIR}"/01scsi-useful
	for aa in `cat "${FILESDIR}"/mconvert.link`
	do
		dosym  mconvert.sh /usr/bin/scsi-useful/$aa
	done
}
