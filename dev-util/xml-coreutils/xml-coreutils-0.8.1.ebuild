# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="4"
inherit autotools eutils

DESCRIPTION="A collection of Unix/POSIX command line tools for processing XML files"
HOMEPAGE="http://xml-coreutils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/slang"
RDEPEND="${DEPEND}"
