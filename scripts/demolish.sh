#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

kubeadm reset -f
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ip link del flannel.1
ip link del cni0
rm -rf $HOME/.kube
rm -f $HOME/Build_HA_RasPi_K8s_Cluster/certs/*

echo 'Done.'

exit 0
