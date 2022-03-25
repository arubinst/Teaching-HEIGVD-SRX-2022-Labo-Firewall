# on efface toute la configuration
nft flush ruleset

# commandes qui sont demandées par la consigne du TP
nft add table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule nat postrouting meta oifname "eth0" masquerade
service ssh start

# création de la table
nft add table firewall

#############################################
#### FORWARD
#############################################

# création de la chaîne pour les règles de forward
nft 'add chain firewall forward {type filter hook forward priority 0 ; policy drop ; }'


# règle pour avoir un firewall stateful qui autorise les réponses à des connexions autorisées
nft add rule firewall forward \
ct state established accept \
comment \"on autorise toutes les réponses à des requêtes que nous avons autorisées\"


#
# règles pour le ping
#

nft add rule firewall forward \
ip saddr 192.168.100.0/24 icmp type echo-request accept \
comment \"autorise le LAN à tout pinger\"

nft add rule firewall forward \
ip saddr 192.168.200.0/24 ip daddr 192.168.100.0/24 icmp type echo-request accept \
comment \"autorise la DMZ à pinger le LAN\"


#
# Règles pour le DNS
#

nft add rule firewall forward \
ip saddr 192.168.100.0/24 udp dport 53 accept \
comment \"autorise le LAN à envoyer des requêtes DNS \(UDP\) sur le WAN\"

nft add rule firewall forward \
ip saddr 192.168.100.0/24 tcp dport 53 accept \
comment \"autorise le LAN à envoyer des requêtes DNS \(TCP\) sur le WAN\"

#
# Règles pour HTTP et HTTPS du LAN vers WAN
#

nft add rule firewall forward \
ip saddr 192.168.100.0/24 ip daddr !=192.168.0.0/16 tcp dport 80 accept \
comment \"autorise le LAN à ouvrir des connexions TCP vers le WAN sur le port 80\"

nft add rule firewall forward \
ip saddr 192.168.100.0/24 ip daddr !=192.168.0.0/16 tcp dport 8080 accept \
comment \"autorise le LAN à ouvrir des connexions TCP vers le WAN sur le port 8080\"


nft add rule firewall forward \
ip saddr 192.168.100.0/24 ip daddr !=192.168.0.0/16 tcp dport 443 accept \
comment \"autorise le LAN à ouvrir des connexions TCP vers le WAN sur le port 443\"


#
# Règles pour HTTP vers le serveur de la DMZ
#

nft add rule firewall forward \
ip daddr 192.168.200.3 tcp dport 80 accept \
comment \"autorise tout le monde à ouvrir des connexions TCP vers le serveur web de la DMZ sur le port 80\"


#
# Règles pour SSH du client LAN vers le serveur de la DMZ
#

nft add rule firewall forward \
ip saddr 192.168.100.3 ip daddr 192.168.200.3 tcp dport 22 accept \
comment \"autorise le client du LAN à ouvrir des connexions TCP vers le serveur web de la DMZ sur le port 22\"



#############################################
#### INPUT
#############################################

# création de la chaîne pour les règles d'input
nft 'add chain firewall input {type filter hook input priority 0 ; policy drop ; }'

# règle pour avoir un firewall stateful qui autorise les réponses à des connexions autorisées
nft add rule firewall forward \
ct state established accept \
comment \"on autorise toutes les réponses à des requêtes que nous avons autorisées\"

#
# Règles pour SSH du client LAN vers le firewall
#

nft add rule firewall input \
ip saddr 192.168.100.3 ip daddr 192.168.100.2 tcp dport 22 accept \
comment \"autorise le client du LAN à ouvrir des connexions TCP vers le firewall sur le port 22\"






# on affiche la configuration obtenue
nft list ruleset
