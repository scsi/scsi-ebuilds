# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/scsi/snapshot-btrfs.git"

inherit git-r3

DESCRIPTION="Snapshot tool for BTRFS on Linux"
HOMEPAGE="https://github.com/scsi/snapshot-btrfs"
LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="sys-fs/btrfs-progs
	virtual/cron"

DOCS=( README )

src_install() {
	default
	# Remove execute flag for crontab files
	#fperms a-x /etc/cron.d/${PN}
}
