# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="This is a set of Plasma Widgets thoughts to be used in conjunction with Grouping Desktop (http://kde-look.org/content/show.php?action=content&content=116926) to control and show information about songs played by Amarok and other players."
HOMEPAGE="http://kde-look.org/content/show.php?content=127019"
SRC_URI="http://kde-look.org/CONTENT/content-files/127019-${P}.tar.bz2"
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
