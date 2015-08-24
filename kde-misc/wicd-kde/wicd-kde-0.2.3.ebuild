# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kosd/kosd-0.4.2.ebuild,v 1.2 2009/10/27 23:42:22 ssuominen Exp $

EAPI=5
inherit kde4-base

DESCRIPTION="Wicd Client KDE is a Wicd client build on the KDE Development Platform."
HOMEPAGE="http://opendesktop.org/content/show.php?content=132366"
SRC_URI="http://opendesktop.org/CONTENT/content-files/132366-${P}.tar.gz"
#        http://opendesktop.org/CONTENT/content-files/132366-wicd-kde-0.2.2.tar.gz

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=kde-base/kdelibs-${KDE_MINIMAL}
	net-misc/wicd"

S=$WORKDIR/${PN}
