# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"
inherit kde4-base

DESCRIPTION="A small utility which bothers you at certain intervals."
HOMEPAGE="http://www.rsibreak.org/"
SRC_URI="http://www.rsibreak.org/files/${P/_beta/-beta}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=$WORKDIR/${P/_beta/-beta}
