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

src_unpack(){
	mkdir "${S}"
}
src_compile(){
	einfo "noneed compile"
}
src_install(){
	exeinto /etc/init.d
	doexe "${FILESDIR}"/static-arp
	insinto /etc/conf.d
	newins "${FILESDIR}"/static-arp.conf static-arp
}
