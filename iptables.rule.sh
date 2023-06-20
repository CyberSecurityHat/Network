#!/bin/bash

# Rule reset
iptables -F

# Chain policy settings
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

# Allow connected session traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow localhost traffic
iptables -A INPUT -i lo -j ACCEPT

# Allow port
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block FIN Scan
iptabels -A INPUT -p tcp --tcp-falg ALL FIN -j LOG --log-prefix "FIN Scan : "
iptables -A INPUT -p tcp --tcp-falg ALL FIN -j DROP

# Block NULL Scan
iptables -A INPUT -p tcp --tcp-flag ALL NONE -j LOG --log-prefix "NULL Scan : "
iptables -A INPUT -p tcp --tcp-flag ALL NONE -j DROP

# Block X-MAS scan 
iptables -A INPUT -p tcp --tcp-flag ALL URG,PSH,FIN -j LOG --log-prefix "X-MAS Scan : "
iptalbes -A INPUT -p tcp --tcp-falg ALL URG,PSH,FIN -j DROP

# Save rules
iptables-save > /etc/sysconfig/iptables

echo "iptables rules updated"