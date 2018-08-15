# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=6
inherit autotools eutils

DESCRIPTION="Proxy for using W3C WebDriver clients to interact with Gecko-based browsers"
HOMEPAGE="https://github.com/mozilla/geckodriver"
#SRC_URI="https://github.com/mozilla/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/mozilla/geckodriver/releases/download/v${PV}/geckodriver-v${PV}-linux64.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
S=${WORKDIR}
#DEPEND="sys-libs/slang"
#RDEPEND="${DEPEND}"
src_install(){
	exeinto /opt/bin
	doexe geckodriver
}
