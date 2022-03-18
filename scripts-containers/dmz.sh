ip route del default
ip route add default via 192.168.200.2

service nginx start
service ssh start