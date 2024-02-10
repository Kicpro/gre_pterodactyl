#!/bin/bash

#
# Variables
#
# Adjust these to match your DDOS Protected VPS & Backend IP's!
#

PROTECTED_IP="XX.XX.XX.XX"

BACKEND_IP="XX.XX.XX.XX"

#
# DO NOT CHANGE ANYTHING BELOW THIS TEXT!
#

# Making sure iptables isn't blocking FORWARD

iptables -P FORWARD ACCEPT

# Enabling IP forwarding and ARP Proxy so we can forward our Protected IP

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.eth0.proxy_arp=1
sysctl -p

# Bring up GRE

modprobe ip_gre
lsmod | grep gre

# Tunnel setup

ip tunnel add gre1 mode gre local $PROTECTED_IP remote $BACKEND_IP ttl 255
ip addr add 10.0.0.1/30 dev gre1
ip link set gre1 up

# NAT configuration

iptables -t nat -A POSTROUTING -s 10.0.0.0/30 ! -o gre+ -j SNAT --to-source $PROTECTED_IP

# Port forwarding

iptables -A FORWARD -d 10.0.0.2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.0.0.2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Route our Protected IP through the Tunnel

ip route add $PROTECTED_IP/32 via 10.0.0.2
