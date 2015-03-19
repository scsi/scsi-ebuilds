# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
KDE_MINIMAL="4.2"
inherit kde4-base

ESVN_REPO_URI="http://gmailnotifier.googlecode.com/svn/trunk/"
DESCRIPTION="A Gmail Notifier plasmoid"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=99709&vote=good&tan=65040184&PHPSESSID=35ffc21d5e2ed6a747d1cf42a87796bc"
SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
RESTRICT="mirror"
DEPEND="kde-base/plasma-workspace
        !kde-misc/plasmoids"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${PN}

src_unpack()
{
	    subversion_src_unpack
}
