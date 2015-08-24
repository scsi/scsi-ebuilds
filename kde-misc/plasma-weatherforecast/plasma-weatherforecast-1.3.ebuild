# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="One more weather plasmoid"
HOMEPAGE="http://www.kde-look.org/content/show.php/weatherforecast?content=92149"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/92149-simpleweatherforecast-${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
	!kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/plasma-simpleweatherforecast-1.3-kde-4.3.80/
