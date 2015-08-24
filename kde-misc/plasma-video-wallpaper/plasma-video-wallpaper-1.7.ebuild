# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Play video as your wallpaper"
HOMEPAGE="http://www.kde-look.org/content/show.php/Animated+Video+Wallpaper?content=112105"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/112105-${PN}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"
