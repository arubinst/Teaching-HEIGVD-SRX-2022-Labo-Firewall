# on efface toute la configuration
nft flush ruleset

# commandes qui sont demandées par la consigne du TP
ip route del default
ip route add default via 192.168.200.2
service nginx start
service ssh start

# on affiche la configuration obtenue
nft list ruleset