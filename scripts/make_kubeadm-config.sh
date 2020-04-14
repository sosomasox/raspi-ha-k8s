#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 LOAD_BALANCER_IP_ADDRESS LOAD_BALANCER_PORT"
    exit 1
fi

LOAD_BALANCER_ADDR=$1
LOAD_BALANCER_PORT=$2

if [ -f $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml ]; then
    mv -f $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml.bk
fi

echo "apiVersion: kubeadm.k8s.io/v1beta1"                                    >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kind: ClusterConfiguration"                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kubernetesVersion: v1.13.5"                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "apiServer:"                                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  certSANs:"                                                           >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  - \"${LOAD_BALANCER_ADDR}\""                                         >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "controlPlaneEndpoint: \"${LOAD_BALANCER_ADDR}:${LOAD_BALANCER_PORT}\"" >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "networking:"                                                           >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  podSubnet: 10.244.0.0/16"                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml

echo 'make kubeadm-config.yaml done.'

exit 0
