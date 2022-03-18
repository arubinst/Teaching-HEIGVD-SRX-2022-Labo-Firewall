# Ajout d'une table filter dans la famille inet (ip/ip6)
nft add table ip filter

# Ajout d'une chaîne contenant les règles pour accepter le ping
nft 'add chain ip filter accept_ping { type filter hook forward  priority 100 ; policy drop ; }'

# Ajout des règles

# Autorise le ping du LAN vers la DMZ

nft add rule ip filter accept_ping icmp type echo-request ip saddr 192.168.100.0/24 ip daddr 192.168.200.0/24 accept

nft add rule ip filter accept_ping icmp type echo-reply ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 accept

# Autorise le ping du LAN vers le WAN

nft add rule ip filter accept_ping icmp type echo-request ip saddr 192.168.100.0/24 meta oif eth0 accept 

nft add rule ip filter accept_ping icmp type echo-reply meta iif eth0 ip daddr 192.168.100.0/24 accept 

# Autorise le ping de la DMZ vers le LAN
nft add rule ip filter accept_ping icmp type echo-request ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 accept

nft add rule ip filter accept_ping icmp type echo-reply ip saddr 192.168.100.0/24 ip daddr 192.168.200.0/24 accept