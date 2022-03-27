#!/usr/sbin/nft -f

nft flush ruleset

# --------------------- #
# NAT                   #
# --------------------- #

# Ajout d'une table "nat"
nft add table ip nat
# Ajout d'une chaine "postrouting" de type nat (hook postrouting)
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'

# https://askubuntu.com/questions/466445/what-is-masquerade-in-the-context-of-iptables
nft add rule nat postrouting meta oifname "eth0" masquerade


# Ajout d'une table "filter" dans la famille ip (ipv4)
nft add table ip filter


# Ajout d'une chaîne contenant les règles pour le hook forward
nft 'add chain ip filter forward { type filter hook forward  priority 100 ; policy drop ; }'

# Ajout des règles


# --------------------- #
# PING                  #
# --------------------- #

# Autorise le ping du LAN vers la DMZ
nft add rule ip filter forward icmp type echo-request ip saddr 192.168.100.0/24 ip daddr 192.168.200.0/24 accept
nft add rule ip filter forward icmp type echo-reply ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 accept

# Autorise le ping du LAN vers le WAN
nft add rule ip filter forward icmp type echo-request ip saddr 192.168.100.0/24 meta oif eth0 accept 
nft add rule ip filter forward icmp type echo-reply meta iif eth0 ip daddr 192.168.100.0/24 accept 

# Autorise le ping de la DMZ vers le LAN
nft add rule ip filter forward icmp type echo-request ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 accept
nft add rule ip filter forward icmp type echo-reply ip saddr 192.168.100.0/24 ip daddr 192.168.200.0/24 accept

# --------------------- #
# DNS                   #
# --------------------- #

# Autorise le DNS
nft add rule ip filter forward ip saddr 192.168.100.0/24 meta oif eth0 tcp dport 53 accept
nft add rule ip filter forward ip saddr 192.168.100.0/24 meta oif eth0 udp dport 53 accept 

nft add rule ip filter forward meta iif eth0 ip daddr 192.168.100.0/24 tcp sport 53 accept
nft add rule ip filter forward meta iif eth0 ip daddr 192.168.100.0/24 udp sport 53 accept 

# --------------------- #
# SSH                   #
# --------------------- #

# Autorise LAN to DMZ .3 Host
nft add rule ip filter forward ip saddr 192.168.100.3 ip daddr 192.168.200.3 tcp dport 22 accept
nft add rule ip filter forward ip saddr 192.168.200.3 ip daddr 192.168.100.3 tcp sport 22 accept

# Ajout d'une chaîne contenant les règles pour le hook input
nft 'add chain ip filter input { type filter hook input  priority 100 ; policy drop ;}'
# Ajout d'une chaîne contenant les règles pour le hook input
nft 'add chain ip filter output { type filter hook output  priority 100 ; policy drop ;}'

# Autorise LAN to FW
nft add rule ip filter input ip saddr 192.168.100.3 ip daddr 192.168.100.2 tcp dport 22 accept
nft add rule ip filter output ip saddr 192.168.100.2 ip daddr 192.168.100.3 tcp sport 22 accept

# --------------------- #
# HTTP                  #
# --------------------- #