# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SSL VPN Client for Fortinet"
HOMEPAGE="http://www.forticlient.com/"
#SRC_URI="ftp://pftpintl:F0rt1intl@support.fortinet.com/FortiGate/v5.00/5.0/5.0.7/SSL-VPN/forticlientsslvpn_linux_${PV}.tar.gz"
SRC_URI="ftp://pftpintl:sgn89IOngs@support.fortinet.com/FortiGate/v5.00/5.2/5.2.2/VPN/SSLVPNTools/forticlientsslvpn_linux_${PV}.tar.gz"
LICENSE="FortiClientSSLVPN"
SLOT="0"
IUSE=""
KEYWORDS="amd64"
DEPEND=""
RDEPEND="${DEPEND}
	net-dialup/ppp"

S="${WORKDIR}/forticlientsslvpn/64bit"
QA_PREBUILT="opt/forticlient-sslvpn/forticlientsslvpn opt/forticlient-sslvpn/helper/subproc"

src_unpack() {
    unpack ${A}
    cd "${S}"
}

src_install() {
	insinto opt/${PN}
	doins $FILESDIR/forticlientsslvpn.png
	exeinto opt/${PN}
	doexe forticlientsslvpn forticlientsslvpn_cli
	cp -r helper ${D}/opt/forticlient-sslvpn/helper
	fowners root:bin /opt/forticlient-sslvpn/helper/subproc
	fperms 4755 /opt/forticlient-sslvpn/helper/subproc
}

pkg_postinst() {
	ewarn "Forticlient SSL VPN is closed-source."
	einfo "Installed in /opt/forticlient-sslvpn"
}
