#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 ANOTHER_CONTROL_PLANE_NODES_IP_ADDRESS..."
    exit 1
fi

kubeadm reset -f
kubeadm init --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml

sudo -u pi mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo -u pi kubectl apply -f $HOME/Build_RasPi_Kubernetes_Cluster/cni/kube-flannel_v0.12.0-arm.yaml

chmod +x $HOME/Build_HA_RasPi_K8s_Cluster/scripts/scp_cert.sh
$HOME/Build_HA_RasPi_K8s_Cluster/scripts/scp_cert.sh $@

echo 'Done.'

exit 0
