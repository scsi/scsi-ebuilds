# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/acpi4asus/acpi4asus-0.27.ebuild,v 1.3 2004/09/09 16:53:11 kugelfang Exp $

DESCRIPTION="This a little tool that executes programs in a restricted environment. It applies the following restrictions: chroot, chuser, CPU limit, and memory limit."
HOMEPAGE="http://www.wastl.net/projects_html"
#SRC_URI="http://www.wastl.net/download/secdo/${P}.tar.gz"
LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
S=${WORKDIR}/${PN}
src_compile() {
	export LDFLAGS=-lpopt
	make ${PN}
}

src_install() {
	dobin ${PN}
}

