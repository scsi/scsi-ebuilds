#inherit eutils

DESCRIPTION="A tag ebuild made by scsi to build base system."
#SRC_URI=""
HOMEPAGE="http://iekonica.dyndns.org/scsi"

KEYWORDS="x86 amd64 ia64 ppc sparc alpha hppa mips"
SLOT="0"
LICENSE="GPL"
IUSE="scsihome"
RDEPEND="
scsihome? ( sys-power/acpid
net-dialup/rp-pppoe
net-wireless/wireless-tools
net-dns/ddclient )
"
#net-wireless/ipw2200

#sys-power/speedfreq
#src_unpack(){
#}
#src_compile() {
#}
src_install() 
{
	exeinto /etc/profile.d
	doexe ${FILESDIR}/script/profile.scsi.sh
	doexe ${FILESDIR}/script/profile.ps1.sh

	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/script/99scsiextend
	
	dodir /etc/X11/xinit/xinitrc.d
	exeinto /etc/X11/xinit/xinitrc.d
	doexe ${FILESDIR}/script/00-x11-locale
	doexe ${FILESDIR}/script/01-x11-fix-KDE

	dodir /etc/vim
	insinto /etc/vim
	doins ${FILESDIR}/vim/vimrc.local

	dodir /etc/sysctl.d
	insinto /etc/sysctl.d
	doins ${FILESDIR}/sysctl.d/01-sysctl-scsi.conf

#	dodir /etc/conf.d
#	cat /etc/conf.d/rc| sed 's/RC_DEVICE_TARBALL="yes"/RC_DEVICE_TARBALL="no"/' >${D}/etc/conf.d/rc
#	cat /etc/conf.d/iptables |sed  's/SAVE_ON_STOP="yes"/SAVE_ON_STOP="no"/'|sed 's/IPTABLES_SAVE="\/var\/lib\/iptables\/rules-save"/IPTABLES_SAVE="\/etc\/iptables\/rules-save"/' >${D}/etc/conf.d/iptables

#	dodir /etc/iptables
#	insinto /etc/iptables
#	doins ${FILESDIR}/iptables/rules-save

	if use scsihome
	then
		insinto /etc/init.d
		doins ${FILESDIR}/init.d/closewireless

		dodir /etc/acpi
		exeinto /etc/acpi
		doexe ${FILESDIR}/acpi/{hotkey.sh,wireless.sh}

		dodir /etc/acpi/event
		insinto /etc/acpi/event
		doins ${FILESDIR}/acpi/event/hotkey

		dodir /etc/ppp
		insinto /etc/ppp
		doins ${FILESDIR}/ppp/{ip-up.local,ip-down.local}

		dodir /etc/ddclient
		insinto /etc/ddclient
		doins ${FILESDIR}/ddclient/ddclient.conf
	fi

#	( cat /etc/crontab ; echo "*/10 * * * *     /root/system/system/checkadsl.sh
# 0 22 * * *       /root/system/system/updatetime.sh
# 40 12,3 * * *     /bin/nice -n 19 /usr/sbin/esync;/usr/bin/emerge -uDpv world|/bin/mail -s "scsinb: emerge report" scsi@seed.net.tw" ) > ${T}/crontab
#	crontab  ${T}/crontab

#	cd ${D}/etc/
	#dosym /usr/share/zoneinfo/Asia/Taipei /etc/localtime
#	dosym grub.conf /boot/grub/grub.conf	/etc/
}

pkg_postinst()
{
	etc-update
#	for aa in alsasound coldplug closewireless
#	do
#		rc-update add $aa boot
#	done

#	for aa in hotplug fcron esound iptables acpid rp-pppoe postfix xinetd
#	do
#		rc-update add $aa default
#	done

#	/usr/sbin/postalias /etc/mail/aliases
}
