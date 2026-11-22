#!/bin/bash

iptables -D DOCKER-USER -j HW4-FIREWALL 2>/dev/null
iptables -F HW4-FIREWALL 2>/dev/null
iptables -X HW4-FIREWALL 2>/dev/null

echo "Firewall rules removed."
