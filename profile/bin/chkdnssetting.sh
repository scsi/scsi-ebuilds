grep -q ^nameserver /etc/resolv.conf && exit
dhfile=`ls -1t /var/lib/NetworkManager/dhclient-*.lease|head -1`
[ -f "$dhfile" ] || exit
sv="`grep "domain-name " $dhfile|tail -1|cut -d'"' -f2`"
nv="`grep "domain-name-servers " $dhfile|tail -1|awk '{print $3}'|cut -d\; -f1`"
[ -n "$sv"  ] && echo "search $sv" >>/etc/resolv.conf
[ -n "$nv" ] && echo "nameserver $nv" >>/etc/resolv.conf
