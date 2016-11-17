#!/bin/bash
. `dirname $(which $0)`/commfunc.sh
LOGDIR=/var/log
LOGFILE=$LOGDIR/scsibk.log
SNAP_VERSION=`date "+%Y-%m-%d_%H-%M-%S_%s"`
log "start backup $SNAP_VERSION"
(
{ [ -d /boot/grub ] || mount /boot; } \
  && ssh t1srv "test -f /mnt/scsibk/.keep || mount /mnt/scsibk" \
  && ssh t1srv "mkdir -p /mnt/scsibk/acernb /mnt/scsibk/snapshot" \
  && rsync -azO --inplace --log-format="%o %n %l" --delete --delete-excluded \
    --exclude="var/log/*" \
    --exclude="var/tmp/*" \
    --exclude="var/lib/run/*" \
    --exclude="var/lib/sddm/.cache" \
    --exclude="var/lib/sddm/.dbus" \
    --exclude="var/lib/sddm/.local" \
    --exclude="var/lib/sddm/.xsession-errors" \
    --exclude="var/lib/upower/*" \
    --exclude="var/lib/systemd/coredump/*" \
    --exclude="usr/portage/distfiles/*" \
    --exclude="usr/portage/tmp/*" \
    --exclude=".btrfs/snapshot/*" \
    --exclude="var/lib/docker/*" \
    --exclude="home/scsi/.cache/*" \
    --exclude="home/scsi/.m2/repository/*" \
    /{bin,boot,etc,lib32,lib64,opt,root,sbin,usr,var,home} t1srv:/mnt/scsibk/acernb/ \
  && ssh t1srv "btrfs subvol snapshot -r /mnt/scsibk /mnt/scsibk/snapshot/$SNAP_VERSION" \
  && umount /boot
 )2>&1|log
[ ${PIPESTATUS[0]} = 0 ] || { log "transfer data fail."; exit 1; }

log "transfer data success."

SNAP_LIST=`ssh t1srv "ls /mnt/scsibk/snapshot"`
dsec=`date "+%s" --date="3 month ago"`
#dsec=`date "+%s" --date="90 day ago"`

IFS="
"
unset del_list
for snapinfo in $SNAP_LIST ; do
    baksec=`echo $snapinfo|cut -d_ -f3`
    [ $dsec -gt $baksec ] && del_list="$del_list
$snapinfo"
done

for snap in `echo "$del_list"|awk '{print $1}'`; do
    echo remove $snap
    echo "remove $snap"|log
    ssh t1srv "btrfs subvol delete /mnt/scsibk/snapshot/$snap" && log "remove $snap success." ||  log "remove $snap fail."
done
ssh t1srv "umount /mnt/scsibk" || log "umount /mnt/scsibk fail."

log "Used time:`usedtime`"
