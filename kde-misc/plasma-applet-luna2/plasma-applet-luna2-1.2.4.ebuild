# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="This is a plasma applet that displays the moon phases"
HOMEPAGE="http://www.kde-look.org/content/show.php/Luna+2?content=100337"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/100337-${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}
