#!/bin/bash
retval=0
emerge -vp xorg-x11 &>/dev/null
retval=$?
while [[ $retval == 1 ]]; do
       package=$(emerge -vp xorg-x11 |grep "^\-" | cut -f 2 -d " " | head -n 1)
       atom="~"
       echo "unmasking package $package"
       echo "$atom$package" >> /etc/portage/package.keywords
       emerge -vp xorg-x11 &>/dev/null
       retval=$?
done
