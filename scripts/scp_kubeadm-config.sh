#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTROL_PLANE_NODES_IP_ADDRESS..."
    exit 1
fi
 
USER=pi

for host in $@; do
    scp $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml "${USER}"@$host:Build_HA_RasPi_K8s_Cluster/manifests/
done

echo 'scp kubeadm-config.yaml done.'

exit 0
