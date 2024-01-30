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

GATEWAY_IP=$(ip route show default 0.0.0.0/0 | awk '{print $3}')
INTERFACE=$(ip -br addr show | grep $BACKEND_IP | awk '{print $1}')

# Bring up GRE

modprobe ip_gre
lsmod | grep gre

# Tunnel setup

ip tunnel add gre1 mode gre local $BACKEND_IP remote $PROTECTED_IP ttl 255
ip addr add 10.0.0.2/30 dev gre1
ip link set gre1 up

# New routes implementations

echo '100 GRE' >> /etc/iproute2/rt_tables
ip rule add from 10.0.0.0/30 table GRE
ip route add default via 10.0.0.1 table GRE

# Set DNS servers

echo 'nameserver 1.1.1.1' > /etc/resolv.conf
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# WARNING: This will cut all access to your BACKEND IP!

ip route add $PROTECTED_IP via $GATEWAY_IP dev $INTERFACE onlink
ip route replace default via 10.0.0.1

# Sets proper MTU

ip link set mtu 1440 gre0
ip link set mtu 1440 gre1