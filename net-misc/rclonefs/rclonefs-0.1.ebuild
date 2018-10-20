# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A set of useful tools made by scsi"
HOMEPAGE="https://github.com/ncw/rclone/wiki/rclone-fstab-mount-helper-script"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RDEPEND=""
RDEPEND="net-misc/rclone"

src_unpack(){
:
}
src_compile(){
:
}
src_install(){
	exeinto /usr/bin
	doexe ${FILESDIR}/bin/rclonefs
}
