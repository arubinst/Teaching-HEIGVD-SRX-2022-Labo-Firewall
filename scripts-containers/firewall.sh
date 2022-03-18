# on efface toute la configuration
nft flush ruleset

# commandes qui sont demandées par la consigne du TP
nft add table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule nat postrouting meta oifname "eth0" masquerade
service ssh start


# on affiche la configuration obtenue
nft list ruleset

