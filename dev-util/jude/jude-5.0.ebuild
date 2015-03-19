# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-dicts/stardict/stardict-2.4.1.ebuild,v 1.1 2003/10/30 10:02:39 liquidx Exp $

# NOTE: Even though the *.dict.dz are the same as dictd/freedict's files,
#       their indexes seem to be in a different format. So we'll keep them
#       seperate for now.

inherit eutils

IUSE="kde"
DESCRIPTION="JUDE (Java and UML Developers' Environment) is a unique UML modeling tool which supports object-oriented software design in Java(TM) combined with Mind Map(R)"
HOMEPAGE="http://jude-users.com/en/"
SRC_URI="${PN}-community-${PV/\./_}.zip"

LICENSE="JUDE's license agreements"
SLOT="0"
KEYWORDS="x86 ppc"
RDEPEND=">=virtual/jre-1.4.2"
DEPEND="${RDEPEND}"
S=${WORKDIR}/${PN}_community
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please download ${PN}-community-${PV/\./_}.zip"
	einfo "from http://jude.change-vision.com/jude-web/product/community.html and place them in ${DISTDIR}"
}

src_unpack() 
{
	unpack ${A}
}
#src_compile()
#{
#}
src_install()
{
	cd ${S}
	cat jude | sed -s "s/\`dirname \$0\`/\/opt\/jude/">jude.new
	insinto /opt/${PN}
	doins *

	exeinto /opt/${PN}
	newexe jude.new jude
	dodir /opt/bin
	cd ${D}/opt/bin
	dosym /opt/jude/jude /opt/bin/jude
	
	if use kde
	then
		insinto /usr/share/applications/kde/
		doins ${FILESDIR}/${PN}.desktop
	fi
}
