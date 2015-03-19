# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"

inherit kde4-base

DESCRIPTION="Plasma Applet to countdown to a specific time"
HOMEPAGE="http://www.kde-look.org/content/show.php/countdown?content=74950"
SRC_URI="http://ppa.launchpad.net/andersin/ubuntu/pool/main/p/${PN}/${PN}_${PV}.orig.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
		!kde-misc/plasmoids"
RDEPEND="${DEPEND}"
PATCHES=( "$FILESDIR/plasmoid-countdown-0.2.2-kde4_2.patch" )
