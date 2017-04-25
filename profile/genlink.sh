echo pls watch this file.; exit
[ -d /etc/portage/profile ] || mkdir /etc/portage/profile
ln -s ../../../usr/portage/scsi-ebuilds/profile/package.provided /etc/portage/profile/package.provided
ln -s ../../../usr/portage/scsi-ebuilds/profile/use.mask /etc/portage/profile/use.mask
for aa in keywords use mask unmask; do
  [ -d /etc/portage/package.$aa ] || mkdir /etc/portage/package.$aa
  ln -s ../../../usr/portage/scsi-ebuilds/profile/package.$aa /etc/portage/package.$aa/scsi-ebuilds
done
