# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Just a simple plasmoid that checks your inbox for new mails."
HOMEPAGE="http://www.kde-look.org/content/show.php/mail_plasmoid?content=98952"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/98952-${PN}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}
