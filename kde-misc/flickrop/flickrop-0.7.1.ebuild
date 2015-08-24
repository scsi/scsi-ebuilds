# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit kde4-base

DESCRIPTION="A Plasma applet showing the most interesting pictures on Flickr"
HOMEPAGE="http://www.kde-look.org/content/show.php/Flickr+On+Plasma?content=94800"
SRC_URI="http://www.bramschoenmakers.nl/sites/bramschoenmakers.nl/www/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+marble"
RESTRICT="mirror"

RDEPEND="${RDEPEND}
	marble? ( >=kde-base/marble-${KDE_MINIMAL} )"

src_prepare() {
	sed -i -e "s/NOT WITHOUT_MARBLE/WITH_MARBLE/" CMakeLists.txt || die "sed failed"
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with marble MARBLE)"
	kde4-base_src_configure
}
