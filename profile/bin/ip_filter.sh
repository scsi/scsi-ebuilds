#!/bin/bash

echo "1" > /proc/sys/net/ipv4/ip_forward

/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -t nat -F
/sbin/iptables -t nat -X

/sbin/iptables -N synflood
/sbin/iptables -A synflood -p tcp --syn -m limit --limit 1/s --limit-burst 18 -j RETURN
/sbin/iptables -A synflood -p tcp -j REJECT --reject-with tcp-reset
/sbin/iptables -A INPUT -p tcp -m state --state NEW -j synflood

# for msnbot
/sbin/iptables -A INPUT -i eth0 -p tcp -s 64.4.0.0/16 -j DROP
/sbin/iptables -A INPUT -i eth0 -p tcp -s 65.54.0.0/16 -j DROP
/sbin/iptables -A INPUT -i eth0 -p tcp -s 207.46.0.0/16 -j DROP

/sbin/iptables -A INPUT -s 0/0 -p tcp --dport smtp -j ACCEPT
/sbin/iptables -A INPUT -s 0/0 -p tcp --sport domain -j ACCEPT
/sbin/iptables -A INPUT -s 0/0 -p udp --sport domain -j ACCEPT
/sbin/iptables -A INPUT -p icmp -j ACCEPT
/sbin/iptables -A INPUT -s localhost -j ACCEPT
/sbin/iptables -A INPUT -s 0/0 -p tcp --dport rsync -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport ssh -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport http -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport https -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport auth -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport mysql -j DROP

/sbin/iptables -A INPUT -p tcp --dport 1024:65535 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 1024:65535 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport ntp -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.119.0/24 -j ACCEPT
/sbin/iptables -A INPUT -j REJECT
