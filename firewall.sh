#!/bin/bash

modprobe br_netfilter
sysctl -w net.bridge.bridge-nf-call-iptables=1

# Try not to duplicate chain
iptables -D DOCKER-USER -j HW4-FIREWALL 2>/dev/null
iptables -F HW4-FIREWALL 2>/dev/null
iptables -X HW4-FIREWALL 2>/dev/null

# Create new chain
iptables -N HW4-FIREWALL 2>/dev/null

# Allow Established/Related
iptables -A HW4-FIREWALL \
	-s 172.30.0.10 \
	-m conntrack --ctstate ESTABLISHED,RELATED \
	-j ACCEPT

iptables -A HW4-FIREWALL \
	-d 172.30.0.10 \
	-m conntrack --ctstate ESTABLISHED,RELATED \
	-j ACCEPT

# Agent to web
iptables -A HW4-FIREWALL \
	-s 172.30.0.10 -d 172.30.0.40 \
	-p tcp --dport 8000 \
	-m conntrack --ctstate NEW \
	-j ACCEPT

# Agent to mock
iptables -A HW4-FIREWALL \
	-s 172.30.0.10 -d 172.30.0.66 \
	-p tcp --dport 8080 \
	-m conntrack --ctstate NEW \
	-j LOG --log-prefix "HW4-C2-DROP: "

# Drop new connections from agent
iptables -A HW4-FIREWALL \
	-s 172.30.0.10 \
	-m conntrack --ctstate NEW \
	-j DROP

# Ignore unrelated
iptables -A HW4-FIREWALL \
	-j RETURN

iptables -I DOCKER-USER 1 -j HW4-FIREWALL
echo "Firewall rules enforced."
