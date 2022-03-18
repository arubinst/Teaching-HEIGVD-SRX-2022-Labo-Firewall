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


# on affiche la configuration obtenue
nft list ruleset

