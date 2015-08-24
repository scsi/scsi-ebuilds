# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="A weather-aware wallpaper for KDE's Plasma desktop shell"
HOMEPAGE="http://www.kde-look.org/content/show.php/Weather+Wallpaper+Plugin?content=102185"
SRC_URI="https://edge.launchpad.net/%7Eechidnaman/+archive/ppa/+files/plasma-wallpaper-weather_${PV}.orig.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
PATCHES=( "$FILESDIR/use_last_used.patch" )
