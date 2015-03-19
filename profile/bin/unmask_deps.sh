#!/bin/bash
retval=0
emerge -uDNvp $1 &>/dev/null
retval=$?
while [[ $retval == 1 ]]; do
       unset package
       #package=$(emerge -uDNvp $1 |grep "^\-" | cut -f 2 -d " " | head -n 1)
       package=$(emerge -uDNvp $1 |grep "^\-.*masked by: ~x86 keyword" | cut -f 2 -d " " | head -n 1)
       [ -z "$package" ] && { echo $1 is invalid; exit 1; }
       atom="~"
       echo "unmasking package $package"
       echo "$atom$package" >> /etc/portage/package.keywords/scsi-ebuilds.keywords/temp.keywords
       emerge -uDNvp $1 &>/dev/null
       retval=$?
done
