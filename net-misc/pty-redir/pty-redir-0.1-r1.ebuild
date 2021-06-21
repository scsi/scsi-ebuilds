#EAPI=6
#inherit eutils

DESCRIPTION="It was written by 臆p墂 Magos嫕yi for his original VPN mini-HOWTO"
SRC_URI="http://www.shinythings.com/pty-redir/${P}.tgz"
HOMEPAGE="http://www.shinythings.com/pty-redir/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

src_prepare() {
	epatch "${FILESDIR}/gentoo_pty.patch" 
}

src_install() {
	mkdir -p ${D}/usr/sbin
	cp pty-redir ${D}/usr/sbin
}

