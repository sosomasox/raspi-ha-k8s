#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 HAPROXY_PORT CONTROL_PLANES..."
    exit 1
fi

if [ -f $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg ]; then
    mv -f $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg.bk
fi

echo "global" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    log /dev/log    local0" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    log /dev/log    local1 notice" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    chroot /var/lib/haproxy" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    stats timeout 30s" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    user haproxy" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    group haproxy" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    daemon" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    ca-base /etc/ssl/certs" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    crt-base /etc/ssl/private" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    ssl-default-bind-options no-sslv3" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "defaults" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    log global" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    mode tcp" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    option tcp-check" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    option tcplog" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    option  dontlognull" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    retries 6" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    timeout connect 3000ms" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    timeout client  3000ms" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    timeout server  60000ms" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 400 /etc/haproxy/errors/400.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 403 /etc/haproxy/errors/403.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 408 /etc/haproxy/errors/408.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 500 /etc/haproxy/errors/500.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 502 /etc/haproxy/errors/502.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 503 /etc/haproxy/errors/503.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    errorfile 504 /etc/haproxy/errors/504.http" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "frontend kube-apiserver" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    bind *:9000" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    default_backend kube-apiserver" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "backend kube-apiserver" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    balance roundrobin" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
echo "    option redispatch" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg

count=0

for host in $@; do
    if [ $count -ne 0 ]; then
        echo "    server master$count $host:6443 check inter 3000ms rise 30 fall 3" >> $HOME/raspi-ha-k8s/rlb/config/haproxy.cfg
    fi

    count=`expr $count + 1`
done

echo 'make haproxy.cfg done.'

exit 0
