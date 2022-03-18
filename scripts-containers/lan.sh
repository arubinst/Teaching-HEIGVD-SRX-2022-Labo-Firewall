# on efface toute la configuration
nft flush ruleset

# commandes qui sont demandées par la consigne du TP
ip route del default
ip route add default via 192.168.100.2

# on affiche la configuration obtenue
nft list ruleset