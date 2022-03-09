FROM ubuntu

RUN apt-get update && apt-get install net-tools nftables iptables iputils-ping iproute2 wget netcat nginx ssh nano traceroute -y

# Modify `sshd_config`
RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config
RUN sed -i s/#PermitEmptyPasswords.*/PermitEmptyPasswords\ yes/ /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM.*/UsePAM no/' /etc/ssh/sshd_config

# Delete root password (set as empty)
RUN passwd -d root
