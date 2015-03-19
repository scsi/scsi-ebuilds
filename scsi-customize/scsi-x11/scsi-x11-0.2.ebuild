inherit eutils

DESCRIPTION="A tag ebuild made by scsi to build x11."
#SRC_URI=""
HOMEPAGE="http://iekonica.dyndns.org/scsi"

KEYWORDS="x86 amd64 ia64 ppc sparc alpha hppa mips"
SLOT="0"
LICENSE="GPL"
IUSE=""
LINGUAS="zh_TW"
RDEPEND="
scsi-customize/scsi-basesystem
x11-drivers/ati-drivers
kde-base/kde
kde-base/kde-i18n
app-i18n/skim
app-i18n/scim-tables
app-i18n/scim-qtimm
media-sound/kamix
gnome-extra/drwright
mail-client/kcheckgmail
kde-misc/kooldock
kde-misc/styleclock
net-misc/knetmonapplet
media-plugins/xmms-kde
kde-misc/kpager2
kde-misc/ksynaptics
kde-misc/mtaskbar
kde-misc/systemtrayapplet2
x11-misc/3ddesktop
app-dicts/stardict
app-dicts/stardict-cdict-en-zh-big5
app-dicts/stardict-cedict-zh-en-big5
app-dicts/stardict-dictd-devils
app-dicts/stardict-dictd-elements
app-dicts/stardict-dictd-gazetteer
app-dicts/stardict-dictd-gcide
app-dicts/stardict-dictd-hitchcock
app-dicts/stardict-dictd-wn
app-dicts/stardict-dictd-world95
app-dicts/stardict-langdao-en-zh-big5
app-dicts/stardict-langdao-zh-en-big5
app-dicts/stardict-oxford-en-zh-big5
app-dicts/stardict-quick-eng-eng
app-dicts/stardict-wyabdcrealpeopletts
app-dicts/stardict-xdict-en-zh-big5
app-dicts/stardict-xdict-zh-en-big5
media-sound/xmms
media-video/kmplayer
media-video/realplayer
app-cdr/k3b
media-video/emovix
net-im/skype
www-client/mozilla-firefox
mail-client/mozilla-thunderbird
net-www/netscape-flash
net-www/mplayerplug-in
media-gfx/gthumb
app-emulation/vmware-workstation
media-fonts/fireflysung
media-fonts/cwttf
media-fonts/hkscs-ming
media-fonts/sinicafonts
dev-util/umbrello
x11-themes/baghira
x11-themes/gtk-engines-qt
kde-base/kbabel
"
#net-misc/d4x
#media-fonts/wangttf
#app-i18n/scim-chewing
#kde-misc/styleclock

#src_unpack(){
#}
#src_compile() {
#}
src_install()
{
		dodir /usr/share/scim/tables
		insinto /usr/share/scim/tables
		doins ${FILESDIR}/scim/liu-uni.txt.in

		dodir /usr/share/scim/icons
		insinto /usr/share/scim/icons
		doins ${FILESDIR}/scim/liu.png
}
