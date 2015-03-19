# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pure-ftpd/pure-ftpd-1.0.20-r1.ebuild,v 1.4 2005/02/03 13:50:19 gustavoz Exp $

inherit eutils

DESCRIPTION="configured start method for pure-ftpd"
HOMEPAGE="http://www.pureftpd.org/"
SRC_URI="ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/${P/-extend/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha ~hppa amd64 ~ia64 ppc64"
IUSE=""

DEPEND="net-ftp/pure-ftpd"

S=${WORKDIR}/${P/-extend/}

src_compile() {
	cd ${S}
	econf \
		--with-altlog --with-extauth \
		--with-puredb --with-cookie \
		--with-throttling --with-ratios \
		--with-quotas --with-ftpwho \
		--with-uploadscript --with-virtualhosts \
		--with-diraliases --with-peruserlimits \
		--with-largefile || die "econf failed"
}

src_install() {
	
	#diropts -m0755
	#dodir /etc/pure-ftpd
	insopts -m 0644
	insinto /etc
	doins configuration-file/pure-ftpd.conf
	sed "s/\#\ PureDB\ \ /PureDB\ \ /" < configuration-file/pure-ftpd.conf >${TMPDIR}/pure-ftpd.conf
	doins ${TMPDIR}/pure-ftpd.conf

	dodir /usr/sbin
	exeopts -m 0744
	exeinto /etc/init.d
	newexe ${FILESDIR}/pure-ftpd.init cpure-ftpd
	exeinto /usr/sbin
	doexe configuration-file/pure-config.pl
	doexe configuration-file/pure-config.py
	einfo "creating puer DB"
	touch ${D}/etc/pureftpd.passwd
	pure-pw mkdb ${D}/etc/pureftpd.pdb -f ${D}/etc/pureftpd.passwd
}

pkg_postinst() {
	einfo "Before starting Pure-FTPd, you have to edit the /etc/conf.d/pure-ftpd file."
	echo
	ewarn "It's *really* important to read the README provided with Pure-FTPd."
	ewarn "Check out - http://www.pureftpd.org/README"
	ewarn "And for SSL/TLS help - http://www.pureftpd.org/README.TLS"
}
