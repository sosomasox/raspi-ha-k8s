#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 HAPROXY_PORTx CONTROL_PLANES..."
    exit 1
fi

if [ -f $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg ]; then
    mv -f $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg.bk
fi

echo "global" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    log /dev/log    local0" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    log /dev/log    local1 notice" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    chroot /var/lib/haproxy" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    stats timeout 30s" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    user haproxy" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    group haproxy" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    daemon" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    ca-base /etc/ssl/certs" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    crt-base /etc/ssl/private" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    ssl-default-bind-options no-sslv3" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "defaults" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    log global" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    mode    http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    option  httplog" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    option  dontlognull" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    retries 10" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    timeout connect 3000ms" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    timeout client  3000ms" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    timeout server  60000ms" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 400 /etc/haproxy/errors/400.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 403 /etc/haproxy/errors/403.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 408 /etc/haproxy/errors/408.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 500 /etc/haproxy/errors/500.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 502 /etc/haproxy/errors/502.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 503 /etc/haproxy/errors/503.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    errorfile 504 /etc/haproxy/errors/504.http" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "frontend kube-apiserver" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    bind *:9000" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    default_backend kube-apiserver" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    mode tcp" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    option tcplog" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    log global" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "backend kube-apiserver" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    mode tcp" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    option tcp-check" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    balance roundrobin" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    option redispatch" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
echo "    retries 3" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg

count=0

for host in $@; do
    if [ $count -ne 0 ]; then
        echo "    server control-plane$count $host:6443 check inter 3000ms rise 30 fall 3" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/haproxy.cfg
    fi

    count=`expr $count + 1`
done

echo 'make haproxy.cfg done.'

exit 0
