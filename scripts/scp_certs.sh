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

cp -f /etc/kubernetes/pki/ca.crt             $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.crt
cp -f /etc/kubernetes/pki/ca.key             $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.key
cp -f /etc/kubernetes/pki/sa.key             $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.key
cp -f /etc/kubernetes/pki/sa.pub             $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.pub
cp -f /etc/kubernetes/pki/front-proxy-ca.crt $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt
cp -f /etc/kubernetes/pki/front-proxy-ca.key $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key
cp -f /etc/kubernetes/pki/etcd/ca.crt        $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt
cp -f /etc/kubernetes/pki/etcd/ca.key        $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key
cp -f /etc/kubernetes/admin.conf             $HOME/Build_HA_RasPi_K8s_Cluster/certs/admin.conf

for host in $@; do
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.crt             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.key             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.key             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.pub             "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt        "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key        "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
    scp $HOME/Build_HA_RasPi_K8s_Cluster/certs/admin.conf         "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/certs/
done

echo 'Done.'

exit 0
