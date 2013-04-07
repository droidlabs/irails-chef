#set interfaces
WAN=eth0
#LAN=eth0

#clean rules tables
iptables -F
iptables -t nat -F
iptables -F INPUT
iptables -F OUTPUT.
iptables -F FORWARD
iptables -t mangle -F

#set default policy
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -I INPUT -i lo -j ACCEPT

#allow services
iptables -A INPUT -p TCP --dport 80 -i $WAN -j ACCEPT
iptables -A INPUT -p TCP --dport 443 -i $WAN -j ACCEPT
iptables -A INPUT -p TCP --dport 22 -i $WAN -j ACCEPT
iptables -A INPUT -p TCP --dport 8000 -i $WAN -j ACCEPT
iptables -A INPUT -p TCP --dport 9292 -i $WAN -j ACCEPT

#allow icmp
iptables -I INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -I INPUT -p icmp --icmp-type source-quench -j ACCEPT
iptables -I INPUT -p icmp --icmp-type time-exceeded -j ACCEPT

#block bad
iptables -A INPUT -i $WAN -m state --state NEW,INVALID -j DROP
iptables -A FORWARD -i $WAN -m state --state NEW,INVALID -j DROP

#set type of service
iptables -t mangle -A OUTPUT -p tcp  --dport 80 -j TOS --set-tos minimize-delay

iptables -A INPUT -j REJECT
iptables -A FORWARD -j REJECT
iptables -A OUTPUT -j ACCEPT
