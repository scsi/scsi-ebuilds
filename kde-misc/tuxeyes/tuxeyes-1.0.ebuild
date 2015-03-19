# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Wear your desktop with a funny Tux who follows your mouse with his eyes."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=120161"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/120161-Tux_Eyes.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/Tux_Eyes
