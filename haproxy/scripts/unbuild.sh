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

systemctl stop haproxy keepalived
apt-mark unhold haproxy keepalived
apt remove -y haproxy keepalived
iptables -D INPUT -p tcp -m tcp --dport ${HAPROXY_PORT} -j ACCEPT

if [ -f /etc/keepalived/keepalived.conf.bk ]; then
    mv -f /etc/keepalived/keepalived.conf.bk /etc/keepalived/keepalived.conf
fi

if [ -f /etc/haproxy/haproxy.cfg.bk ]; then
    mv -f /etc/haproxy/haproxy.cfg.bk /etc/haproxy/haproxy.cfg
fi

if [ -f /etc/rc.local ]; then
    cp /etc/rc.local /etc/rc.local.bk
    rm -f /etc/rc.local
fi

touch /etc/rc.local
chmod 755 /etc/rc.local

while read line
do
    if [ "$line" = "iptables -A INPUT -p tcp -m tcp --dport ${HAPROXY_PORT} -j ACCEPT" ]; then
        echo >> /dev/null
    else
        echo $line >> /etc/rc.local
    fi
done < /etc/rc.local.bk

echo
echo 'unbuild done.'

exit 0
