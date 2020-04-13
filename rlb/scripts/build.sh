#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 HAPROXY_PORT"
    exit 1
fi

HAPROXY_PORT=$1

apt update && apt install -y haproxy=1.8.19-1+rpi1 keepalived=1:2.0.10-1
apt-mark hold haproxy keepalived
systemctl stop haproxy keepalived
systemctl enable haproxy keepalived
iptables -A INPUT -p tcp -m tcp --dport ${HAPROXY_PORT} -j ACCEPT

if [ -f /etc/rc.local ]; then
    cp /etc/rc.local /etc/rc.local.bk
    rm -f /etc/rc.local
fi

touch /etc/rc.local
chmod 755 /etc/rc.local

while read line
do
    if [ "$line" = "exit 0" ]; then
        echo "iptables -A INPUT -p tcp -m tcp --dport ${HAPROXY_PORT} -j ACCEPT" >> /etc/rc.local
        echo >> /etc/rc.local
    fi

    echo $line >> /etc/rc.local
done < /etc/rc.local.bk

if [ -f /etc/keepalived/keepalived.conf ]; then
    mv -f /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bk
fi

cp -f /home/pi/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf /etc/keepalived/keepalived.conf

if [ -f /etc/haproxy/haproxy.cfg ]; then
    mv -f /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bk
fi

cp -f /home/pi/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg /etc/haproxy/haproxy.cfg

systemctl start haproxy keepalived


echo
echo 'build done.'

exit 0
