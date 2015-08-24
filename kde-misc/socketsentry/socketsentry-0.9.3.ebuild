# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="A KDE Plasma widget that displays real-time network traffic on your Linux computer."
HOMEPAGE="http://kde-look.org/content/show.php/Socket+Sentry?content=122350"
SRC_URI="http://socket-sentry.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/kdelibs
kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
#S=${WORKDIR}/${PN}
