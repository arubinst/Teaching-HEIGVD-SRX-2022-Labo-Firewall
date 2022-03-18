# on efface toute la configuration
nft flush ruleset

# commandes qui sont demandées par la consigne du TP
nft add table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule nat postrouting meta oifname "eth0" masquerade
service ssh start

# création de la table et de la chaîne pour les règles de filtrage du firewall
nft add table firewall
nft 'add chain firewall forward {type filter hook forward priority 0 ; policy drop ; }'

# règles ping
nft add rule firewall forward \
ip saddr 192.168.100.0/24 icmp type echo-request accept \
comment \"autorise le LAN à tout pinger\"

nft add rule firewall forward \
ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 icmp type echo-request accept \
comment \"autorise la DMZ à pinger le LAN\"

nft add rule firewall forward \
ct state established icmp type echo-reply accept \
comment \"on autorise toutes les réponses à des requêtes de ping autorisées\"


# on affiche la configuration obtenue
nft list ruleset

