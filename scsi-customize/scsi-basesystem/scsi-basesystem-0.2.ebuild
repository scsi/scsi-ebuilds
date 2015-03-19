inherit eutils

DESCRIPTION="A tag ebuild made by scsi to build base system."
#SRC_URI=""
HOMEPAGE="http://iekonica.dyndns.org/scsi"

KEYWORDS="x86 amd64 ia64 ppc sparc alpha hppa mips"
SLOT="0"
LICENSE="GPL"
IUSE=""
RDEPEND="app-admin/sudo
net-wireless/wireless-tools
sys-process/fcron
app-admin/metalog
sys-apps/slocate
sys-process/lsof
sys-apps/lshw
app-portage/gentoolkit
app-portage/gentoolkit-dev
app-portage/esearch
app-editors/vim
media-sound/esound
media-sound/alsa-utils
net-firewall/iptables
net-misc/dhcpcd
sys-power/acpid
net-dialup/rp-pppoe
net-mail/uw-imap
app-misc/screen
net-ftp/ncftp
net-misc/ntp
net-misc/netkit-telnetd
net-misc/netkit-rsh
sys-apps/xinetd
net-dns/ddclient
mail-client/mailx
media-sound/sox
net-analyzer/tcpdump
net-analyzer/nmap
"
#net-wireless/ipw2200

#sys-power/speedfreq
#src_unpack(){
#}
#src_compile() {
#}
src_install() 
{
	dodir /etc
	insinto /etc/profile.d
	doins ${FILESDIR}/script/profile.scsi.sh

	dodir /etc/init.d
	insinto /etc/init.d
	doins ${FILESDIR}/init.d/closewireless

#	dodir /etc/env.d
#	insinto /etc/env.d
#	doins ${FILESDIR}/script/99scsiextend

	dodir /etc/conf.d
	cat /etc/conf.d/rc| sed 's/RC_DEVICE_TARBALL="yes"/RC_DEVICE_TARBALL="no"/' >${D}/etc/conf.d/rc
	cat /etc/conf.d/iptables |sed  's/SAVE_ON_STOP="yes"/SAVE_ON_STOP="no"/'|sed 's/IPTABLES_SAVE="\/var\/lib\/iptables\/rules-save"/IPTABLES_SAVE="\/etc\/iptables\/rules-save"/' >${D}/etc/conf.d/iptables

	dodir /etc/iptables
	insinto /etc/iptables
	doins ${FILESDIR}/iptables/rules-save

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

	( cat /etc/crontab ; echo "*/10 * * * *     /root/system/system/checkadsl.sh
0 22 * * *       /root/system/system/updatetime.sh
40 12,3 * * *     /bin/nice -n 19 /usr/sbin/esync;/usr/bin/emerge -uDpv world|/bin/mail -s "scsinb: emerge report" scsi@seed.net.tw" ) > ${T}/crontab
	crontab  ${T}/crontab

	cd ${D}/etc/
	#dosym /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	dosym grub.conf /boot/grub/grub.conf	/etc/
}

pkg_postinst()
{
	for aa in alsasound coldplug closewireless
	do
		rc-update add $aa boot
	done

	for aa in hotplug fcron esound iptables acpid postfix xinetd
	do
		rc-update add $aa default
	done

	/usr/sbin/postalias /etc/mail/aliases
}
