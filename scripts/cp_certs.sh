#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

mkdir -p /etc/kubernetes/pki/etcd
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.crt             /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/ca.key             /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.pub             /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/sa.key             /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.crt /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/front-proxy-ca.key /etc/kubernetes/pki/
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.crt        /etc/kubernetes/pki/etcd/ca.crt
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/etcd-ca.key        /etc/kubernetes/pki/etcd/ca.key
cp -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/admin.conf         /etc/kubernetes/admin.conf
chown -R root:root /etc/kubernetes/

echo 'Done.'

exit 0
