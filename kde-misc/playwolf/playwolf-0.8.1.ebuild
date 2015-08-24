# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="This plasmoid is a controller and a visualizer of informations about the songs for amarok 2.0"
HOMEPAGE="http://www.kde-look.org/content/show.php/PlayWolf?content=93882"
SRC_URI="http://playwolf.googlecode.com/files/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/kdelibs[semantic-desktop]
kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}
	media-sound/amarok:4"
#PATCHES=( "${FILESDIR}/playwolf_0.8_bix.patch" )
S=${WORKDIR}/${PN}
