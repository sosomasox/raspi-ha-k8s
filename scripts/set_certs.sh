#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTROL_PLANE_NODES_IP_ADDRESS..."
    exit 1
fi

USER=pi

cp -f /etc/kubernetes/pki/ca.crt             /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.crt
cp -f /etc/kubernetes/pki/ca.key             /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.key
cp -f /etc/kubernetes/pki/sa.key             /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.key
cp -f /etc/kubernetes/pki/sa.pub             /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.pub
cp -f /etc/kubernetes/pki/front-proxy-ca.crt /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt
cp -f /etc/kubernetes/pki/front-proxy-ca.key /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key
cp -f /etc/kubernetes/pki/etcd/ca.crt        /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt
cp -f /etc/kubernetes/pki/etcd/ca.key        /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key
cp -f /etc/kubernetes/admin.conf             /home/pi/Build_HA_RasPi_K8s_Cluster/certs/admin.conf

chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.crt
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.key
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.key
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.pub
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key
chown pi:pi /home/pi/Build_HA_RasPi_K8s_Cluster/certs/admin.conf

for host in $@; do
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.crt             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/ca.key             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.key             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/sa.pub             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt        "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key        "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi scp /home/pi/Build_HA_RasPi_K8s_Cluster/certs/admin.conf         "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    sudo -u pi ssh -t "${USER}"@$host "chmod +x Build_HA_RasPi_K8s_Cluster/scripts/cp_certs.sh"
    sudo -u pi ssh -t "${USER}"@$host "sudo Build_HA_RasPi_K8s_Cluster/scripts/cp_certs.sh"

done

echo 'set certs done.'

exit 0
