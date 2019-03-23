# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="local start and stop service"
HOMEPAGE="https://forums.gentoo.org/viewtopic-t-1008262-start-0.html"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RDEPEND=""
RDEPEND="sys-apps/systemd"

src_unpack(){
:
}
src_compile(){
:
}
src_install(){
	insinto /lib/systemd/system
	doins   ${FILESDIR}/local-start-stop.service
	insinto /usr/lib/local-start-stop
	doins   ${FILESDIR}/local-start-stop.sh
	dodir   /etc/local.d/
}
