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
    ssh -t "${USER}"@$host "rm -rf raspi-ha-k8s/manifests/kubeadm-config.yaml"
    scp $HOME/raspi-ha-k8s/manifests/kubeadm-config.yaml "${USER}"@$host:raspi-ha-k8s/manifests/
done

echo 'scp kubeadm-config.yaml done.'

exit 0
