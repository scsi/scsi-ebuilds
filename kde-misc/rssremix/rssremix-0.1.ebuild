# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="This is an animated RSS plasmoid"
HOMEPAGE="http://www.kde-look.org/content/show.php/rssremix?content=102542"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/102542-${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
