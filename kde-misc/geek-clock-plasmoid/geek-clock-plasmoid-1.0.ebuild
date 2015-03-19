# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Geek Clock plasmoid resembles the outlook of the Geek Clock"
HOMEPAGE="http://www.kde-look.org/content/show.php/Geek+Clock?content=107807"
SRC_URI="http://w2f2.com/projects/geekclock/${P}-src.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${P}-src
