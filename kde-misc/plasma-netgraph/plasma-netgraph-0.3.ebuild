# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KDE_MINIMAL="4.2"
inherit kde4-base

DESCRIPTION="Plasma-netgraph is a plasmoid, that displays network usage"
HOMEPAGE="http://www.kde-look.org/content/show.php/plasma-netgraph?content=74071"
SRC_URI="http://ivplasma.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
PATCHES=( "$FILESDIR/plasma-netgraph-kde4_2.patch" )
