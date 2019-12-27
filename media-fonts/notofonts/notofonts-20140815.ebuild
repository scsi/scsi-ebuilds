# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit font

DESCRIPTION="A font family from Google designed to cover all the scripts encoded in Unicode"
HOMEPAGE="https://code.google.com/p/noto/"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

FONT_SUFFIX="ttc ttf otf"
