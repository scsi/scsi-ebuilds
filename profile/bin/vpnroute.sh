route add -net 192.168.10.0/24 dev ppp0
route add -net 192.168.9.0/24 dev ppp0
route add -net 192.168.2.0/24 dev ppp0
route add -net 172.16.0.0/24 dev ppp0
sed -i "/nameserver.*192.168.2/d" /etc/resolv.conf
ping 192.168.10.18
