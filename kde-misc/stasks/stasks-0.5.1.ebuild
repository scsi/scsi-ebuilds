# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="I would like to write something like this http://www.youtube.com/watch?v=4GmEfQ4IYHo"
HOMEPAGE="http://www.kde-look.org/content/show.php/Stasks+for+KDE+4.3+RC1+with+peek?content=108109"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/108109-${P}-peek.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
		!kde-misc/plasmoids"
S=${WORKDIR}/${P}-peek
