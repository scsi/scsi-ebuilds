# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Multiplatform Azure Data Studio from Microsoft"
HOMEPAGE="https://docs.microsoft.com/sql/azure-data-studio"
BASE_URI="https://azuredatastudiobuilds.blob.core.windows.net/releases/${PV}"
SRC_URI="${BASE_URI}/azuredatastudio-linux-${PV}.tar.gz"
RESTRICT="mirror strip bindist"

LICENSE="MICROSOFT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=gnome-base/gconf-3.2.6-r4:2
>=media-libs/libpng-1.2.46:0
>=x11-libs/cairo-1.14.12:0
>=x11-libs/gtk+-2.24.31-r1:2
>=x11-libs/libXtst-1.2.3:0"

RDEPEND="${DEPEND}
>=app-crypt/libsecret-0.18.5:0[crypt]
>=net-print/cups-2.1.4:0
>=x11-libs/libnotify-0.7.7:0
>=x11-libs/libXScrnSaver-1.2.2-r1:0"

QA_PRESTRIPPED="opt/${PN}/azuredatastudio"
QA_PREBUILT="opt/${PN}/azuredatastudio"

pkg_setup() {
	if use amd64; then
		S="${WORKDIR}/azuredatastudio-linux-x64"
	elif use x86; then
		S="${WORKDIR}/azuredatastudio-linux-ia32"
	else
		die
	fi
}

src_install() {
	dodir "/opt"
	cp -pPR "${S}" "${D}/opt/${PN}" || die "Failed to copy files"
	dosym "${EPREFIX}/opt/${PN}/bin/azuredatastudio" "/usr/bin/azuredatastudio"
	newicon "${S}/resources/app/resources/linux/code.png" "azuredatastudio.png"
	make_desktop_entry "azuredatastudio" "Azure Data Studio" "azuredatastudio" "Development;IDE"
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.txt" "LICENSE"
}
