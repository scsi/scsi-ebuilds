# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Plasmoid for fancy representing your tasks and launchers"
HOMEPAGE="http://www.kde-look.org/content/show.php/Fancy+Tasks?content=99737"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/99737-${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
		!kde-misc/plasmoids"
