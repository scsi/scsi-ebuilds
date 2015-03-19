# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-ftp/ncftp/ncftp-3.1.6.ebuild,v 1.3 2003/10/18 01:51:00 raker Exp $

inherit eutils

S=${WORKDIR}/${PN}-v1.0r11

DESCRIPTION="SOCKS 5.0 Server Daemon"
SRC_URI="file://${FILESDIR}/${PN}-v1.0r11.tar.gz"
HOMEPAGE="http://wwww.socks.nec.com/"

SLOT="0"
#LICENSE=" Copyright (c) 1995,1998 NEC Corporation.  Freely Distributable"
LICENSE="NEC Corporation.  Freely Distributable"
KEYWORDS="x86 ppc sparc alpha hppa"
DEPEND="sys-apps/xinetd"
src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/socks5-v1.0r11.gcc.scsi.patch
	cd ${S}/include
	epatch ${FILESDIR}/socks5-v1.0r11.patch1.txt
}
src_compile()
{
	./configure --prefix=/usr \
	--with-srvpidfile=/var/run/socks5.pid \
	--with-libconffile=/etc/libsocks5.conf \
	--with-srvconffile=/etc/socks5.conf \
	--with-syslog-facility \
	--with-threads
	emake
}
src_install() {
	einstall || die
	cd ${D}/usr/bin
# We prefer the s5 prefix; it conflicts less
	mv rarchie s5archie
	mv rfinger s5finger
	mv rftp s5ftp
	mv rping s5ping
	mv rtelnet s5telnet
	mv rtraceroute s5traceroute
	mv rwhois s5whois
# We restore the permissions on the clients in the %files section;
# if they're 111 here then cpio won't be able to read them to build
# the rpm.
	chmod 511 s5*
	strip s5*
# Move the daemon to the sbin directory
	mkdir ../sbin
	strip socks5
	mv socks5 stopsocks ../sbin
# Install the init script
	mkdir -p ${D}/etc/init.d
	cp ${FILESDIR}/socks5.init.gentoo ${D}/etc/init.d/socks5
	mkdir -p ${D}/etc/xinetd.d/
	cp ${FILESDIR}/socks5.xinetd.gentoo ${D}/etc/xinetd.d/socks5
	# Default config file for the clients; no default for the daemon
	mkdir -p ${D}/etc
	echo "socks5 - - - - -" > ${D}/etc/libsocks5.conf
	echo "#auth source-host source-port auth-methods" >${D}/etc/socks5.conf
	echo "#auth - - u" >>${D}/etc/socks5.conf
	echo "#permit  u - ip - - - user" >>${D}/etc/socks5.conf
	echo "#permit  - - ip - - - -" >>${D}/etc/socks5.conf
	echo "#permit auth cmd src-host dest-host src-port dest-port [user-list]">>${D}/etc/socks5.conf
	echo "#permit  n - ip - - - -" >>${D}/etc/socks5.conf

	# Install the 'unsocks' utility
	cp ${FILESDIR}/unsocks  ${D}/usr/bin
	#cinclude
	mkdir -p ${D}/usr/include/socks5
	cp ${S}/include/*.h ${D}/usr/include/socks5
	cd ${D}/usr/include
	epatch ${FILESDIR}/socks.h.patch
	einfo "Plz man socks5.conf to setup /etc/socks5.conf"
}
